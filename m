Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXKIUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXKIUYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXKIUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:24:40 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:63263 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXKIUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:24:39 -0500
Date: Fri, 9 Nov 2007 12:17:11 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       perfmon2-devel@lists.sourceforge.net, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: conflict between tickless and perfmon2
Message-ID: <20071109201711.GA20390@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071109104438.GB18909@frankl.hpl.hp.com> <1194605991.6289.162.camel@twins> <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Fri, Nov 09, 2007 at 07:40:31PM +0100, Thomas Gleixner wrote:
> 
> > > It looks like a solution would be to change the implementation of
> > > timeout-based switching to use HR timers instead. Similar to what is
> > > done for ITIMER_REAL and ITIMER_VIRTUAL.
> 
> Using a hrtimer is perfrectly fine, I'd say it's preferred over hooks in 
> some code which has absoluty no guarantee of being executed periodically 
> or even executed at all. OTOH it seems rather stupid to measure stuff 
> while the system is idle and doing nothing.
> 
I'll start looking into this soon. To answer your point about idle,
this is not because the core is idle that counters do not capture events
related to buses or caches for instance.

-- 
-Stephane
