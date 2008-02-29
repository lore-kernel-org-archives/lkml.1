Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbYB2RS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbYB2RS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYB2RSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:18:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbYB2RSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:18:20 -0500
Date: Fri, 29 Feb 2008 18:17:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080229171737.GA10604@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229164510.GA6850@elte.hu> <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So the kernel is probably fairly odd in generally not asking for any 
> fixed-format stuff at all (like the GNU changelogs do) but instead 
> writing a small human-readable novella ;)

i think it's also a good learning tool. Subscribing to git-commits-head 
might be more useful to a newbie these days than subscribing to lkml :-/

and one area where commit messages are totally important IMO is bug 
forensics. For every regression we find we try to put in the commit ID 
that broke it. Information like that is vital to have a good (and 
objective) picture about how bugs get into and get out of the kernel and 
it also alerts us to change/improve infrastructure if certain categories 
of bugs happen too often.

	Ingo
