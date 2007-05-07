Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXEGOP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXEGOP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXEGOPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:15:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41156 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXEGOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:15:23 -0400
Date: Mon, 7 May 2007 19:52:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       "Tong N. Li" <tong.n.li@intel.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070507142257.GA633@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu> <20070503132932.GA4204@localhost.localdomain> <20070503145318.GA17776@in.ibm.com> <20070503155347.GF19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503155347.GF19966@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 08:53:47AM -0700, William Lee Irwin III wrote:
> On Thu, May 03, 2007 at 08:23:18PM +0530, Srivatsa Vaddagiri wrote:
> > And what about group scheduling extensions? Do you have plans to work on
> > it? I was begining to work on a prototype to do group scheduling based
> > on CFS, basically on the lines of what you and Linus had outlined
> > earlier:
> > 	http://lkml.org/lkml/2007/4/18/271
> > 	http://lkml.org/lkml/2007/4/18/244
> 
> Tong Li's Trio scheduler does a bit of this, though it doesn't seem to
> have the mindshare cfs seems to have acquired.
> 
> The hyperlink seems to have broken, though:
> 	http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch

The big question I have is, how well does DWRR fits into the "currently hot" 
scheduling frameworks like CFS? For ex: if the goal is to do
fair (group) scheduling of SCHED_NORMAL tasks, can CFS and DWRR co-exist?
Both seem to be radically different algorithms and my initial impressions 
of them co-existing is "No", but would be glad to be corrected if I am
wrong. If they can't co-exist, then we need a different way of doing
group scheduling on top of CFS, as that is gaining more popularity on
account of better handling of interactivity.

Tong,
	I understand a center hallmark of DWRR is SMP fairness.
Have you considered how bad/good the other alternative to achieve SMP fairness 
which is in vogue today : pressure/weight based balancing (ex: smpnice and 
CKRM CPU scheduler - ckrm.sourceforge.net/downloads/ckrm-ols03-slides.pdf)?

-- 
Regards,
vatsa
