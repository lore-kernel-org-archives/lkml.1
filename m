Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZIBK6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZIBK6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZIBK6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:58:00 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49869 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZIBK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:58:00 -0400
Date: Wed, 2 Sep 2009 16:27:45 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 0/8] load-balancing and cpu_power -v2
Message-ID: <20090902105745.GA3817@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090901083431.748830771@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901083431.748830771@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:34:31AM +0200, Peter Zijlstra wrote:
> A more complete version, one that compiles and mostly works on the
> simple tests to which it was subjected.

Very nice series.

Will queue it up for testing to see if anything
obvious breaks.

> 
> It still lacks integration with APERF/MPERF because that stuff was
> hidding in some acpi driver instead of placed in arch code for general
> consumption.. will fix.
> 
> Also, SD_SHARE_CPUPOWER seems redundant in the face of sd->level ==
> SD_LV_SIBLING, should we remove the SD_flag or depricate the level?

IIRC, the only place where we used SD_SHARE_CPUPOWER was while assigning
the cpu_power. With the arch_smt_gain() coming into picture, I feel we
can remove the SD_flag.

Not sure what you meant by deprecating the level.
> 
> Anyway, have at it, poke holes and report issues.


-- 
Thanks and Regards
gautham
