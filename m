Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZDNXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZDNXMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZDNXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:12:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34371 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZDNXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:12:27 -0400
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20090414180832.GA25692@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090414165722.GD2089@elte.hu>  <20090414180832.GA25692@elte.hu>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:12:22 -0500
Message-Id: <1239750743.3638.12.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 20:08 +0200, Ingo Molnar wrote: 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > >  39 files changed, 554 insertions(+), 726 deletions(-)
> > 
> > That diffstat is not against current mainline, is it? 
> > Would you mind to send a proper diffstat with the revert 
> > included as well? That will give us a complete picture.
> 
> ok, i did the calculations, and the effect of adding back 
> x86/Voyager is roughly:
> 
>    48 files changed, 5226 insertions(+), 142 deletions(-)
> 
> That's quite a lot, and lets put this into perspective.

Hardly ... you're conflating two issues:  one is what is the burden to
mainline, which the patch series is about, although only patch 1 (and
possibly patch 5) is truly critical to that, the rest are assorted code
moves.



> You are talking about moving ~5000 lines of legacy code back into 
> arch/x86/, for a total of *four* Voyager/Linux systems, which are 
> using _ancient_ 486/P5 era CPUs.

That's factually incorrect on both counts.  But the real point is that
kernel development isn't a popularity contest, it's about the technical
merits of the code ... something you've been conspicuously avoiding.

> Two of these systems are in your house, two are somewhere unknown: 
> their owners certainly never sent bugreports against recent mainline 
> kernels (Voyager didnt even _build_ for a couple of straight kernel 
> releases), and i suspect those boxes are probably decommissioned 
> already.
> 
> A single core on my run-of-the-mill x86 laptop has more computing 
> power than all Voyager/Linux systems on the planet, combined. And 
> you now want to add back support to the mainline arch/x86 code, 
> which we are trying hard to keep running on millions of x86 Linux 
> systems?

Well, what can I say, if your laptop is the speed standard for
acceptable architectures, then I suppose you'll be removing all of the
embedded architectures as well?

In spite of your disdain for older processors, just remember that the
highest x86 processor with a military spec rating is the 486DX, and one
of the things the US department of defence likes about us is that we
still support it.

Actually, there are a lot of quiet projects using linux because we're
happy to support them on older hardware ... it's one of the things that
makes Linux different from, say, windows.

> You still have not given proper justification for doing that ...

The justification is that I'm prepared to maintain it.

> Sorry to be the one to say 'no', but the reasons you gave so far 
> were not very convincing to me.
>  
> Anyway, you seem to be willing to maintain this code it out of tree. 
> If someone owns such an ancient Voyager box and wants to test a new 
> kernel then your tree is a good starting point for doing that. 
> There's really no pressing need to have this in mainline.

So the message you want to be giving out as a maintainer is that
everything should be developed upstream, except when it's x86?

James


