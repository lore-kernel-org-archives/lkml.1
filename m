Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZJTHRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZJTHRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZJTHRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:17:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZJTHRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:17:03 -0400
Date: Tue, 20 Oct 2009 09:17:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <4ADD62CD.3080208@kernel.org>
Message-ID: <alpine.LSU.2.00.0910200915510.8582@wotan.suse.de>
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu>
 <4ADD62CD.3080208@kernel.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009, Tejun Heo wrote:

> Extending the first chunk size shouldn't be difficult on ia64 but other 
> than this, there still is a lot of room left with the current 64k limit, 
> so I think we should be safe for a while.  BTW, I also am curious how 
> lockdep has been coping with the limit.

There is no lockdep on ia64, and we don't have such restriction on .percpu 
section on any other architecture which supports lockdep, right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
