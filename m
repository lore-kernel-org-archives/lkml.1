Return-Path: <linux-kernel-owner+w=401wt.eu-S1767557AbXCIWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767557AbXCIWOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXCIWOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:14:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbXCIWOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:14:00 -0500
Date: Fri, 9 Mar 2007 23:12:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309221233.GA24341@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <45F1D8D7.9040207@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F1D8D7.9040207@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Now it may be that you've got a change that's absolutely great for 
> everyone, and the only blocker is that the FoobieVisor can't deal with 
> it.  OK, great, then you'd have a point.

yep. That's precisely my worry. And it doesnt have to be a 'great' thing 
- just any random small change in the kernel that makes sense: what is 
the likelyhood that it cannot be implemented, no matter what amount of 
insight, paravirt_ops + hyper-ABI emulation hackery, for FoobieVisor, 
because FoobieVisor messed up its ABI.

that likelyhood is a pure function of how FoobieVisor's hypercall ABI is 
shaped. Wow! So can you guess where my fixation about not having too 
many ABIs could possibly originate from? ;-)

Until today everyone on the hypervisor side of the argument pretended 
that paravirt_ops solves all problems and acted stupid when i said an 
ABI is an ABI is an ABI, and that "backwards compatibility" does have 
some technological consequences. _Now_ at least i've got this minimal 
admission that FoobieVisor _might_ break. Quite a breakthrough =B-)

	Ingo
