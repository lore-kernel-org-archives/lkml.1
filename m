Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYIQUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYIQUCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYIQUBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:01:52 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:53987 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIQUBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:01:52 -0400
Date: Wed, 17 Sep 2008 13:01:29 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.27-rc6 regression] Intermittent boot problem with
	2.6.27-rc6
Message-ID: <20080917200129.GD3436@localdomain>
References: <20080916200414.GB16993@localdomain> <1221639786.25574.27.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221639786.25574.27.camel@ymzhang>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 04:23:06PM +0800, Zhang, Yanmin wrote:
>
>On Tue, 2008-09-16 at 13:04 -0700, Ravikiran G Thirumalai wrote:
>> I am trying a few things -- commandline options to eliminate popular
>> suspects (such as unsynced tsc clocksources)  as well as git bisect, but
>> wanted to report the regression in the meanwhile.
>> Here's the dmesg of a 24 core 6 node wedged system.
>Because the git doesn't include my patch. Pls. try it.
>
>http://marc.info/?l=linux-kernel&m=122093094701219&w=2
>

Thanks Yanmin,  Your patch fixes the problem indeed.
The test machine passed  over 10  boots without hanging up.

Kiran
