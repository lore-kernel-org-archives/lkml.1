Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZDNSJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZDNSJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZDNSIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:08:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbZDNSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:08:51 -0400
Date: Tue, 14 Apr 2009 20:08:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
Message-ID: <20090414180832.GA25692@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090414165722.GD2089@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414165722.GD2089@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> >  39 files changed, 554 insertions(+), 726 deletions(-)
> 
> That diffstat is not against current mainline, is it? 
> Would you mind to send a proper diffstat with the revert 
> included as well? That will give us a complete picture.

ok, i did the calculations, and the effect of adding back 
x86/Voyager is roughly:

   48 files changed, 5226 insertions(+), 142 deletions(-)

That's quite a lot, and lets put this into perspective.

You are talking about moving ~5000 lines of legacy code back into 
arch/x86/, for a total of *four* Voyager/Linux systems, which are 
using _ancient_ 486/P5 era CPUs.

Two of these systems are in your house, two are somewhere unknown: 
their owners certainly never sent bugreports against recent mainline 
kernels (Voyager didnt even _build_ for a couple of straight kernel 
releases), and i suspect those boxes are probably decommissioned 
already.

A single core on my run-of-the-mill x86 laptop has more computing 
power than all Voyager/Linux systems on the planet, combined. And 
you now want to add back support to the mainline arch/x86 code, 
which we are trying hard to keep running on millions of x86 Linux 
systems?

You still have not given proper justification for doing that ...

Sorry to be the one to say 'no', but the reasons you gave so far 
were not very convincing to me.
 
Anyway, you seem to be willing to maintain this code it out of tree. 
If someone owns such an ancient Voyager box and wants to test a new 
kernel then your tree is a good starting point for doing that. 
There's really no pressing need to have this in mainline.

	Ingo
