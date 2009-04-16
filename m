Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZDPUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZDPUzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDPUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:55:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48871 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZDPUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:55:03 -0400
Message-ID: <49E79B1E.9090405@garzik.org>
Date: Thu, 16 Apr 2009 16:54:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu>
In-Reply-To: <20090414180832.GA25692@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>
>>>  39 files changed, 554 insertions(+), 726 deletions(-)
>> That diffstat is not against current mainline, is it? 
>> Would you mind to send a proper diffstat with the revert 
>> included as well? That will give us a complete picture.
> 
> ok, i did the calculations, and the effect of adding back 
> x86/Voyager is roughly:
> 
>    48 files changed, 5226 insertions(+), 142 deletions(-)
> 
> That's quite a lot, and lets put this into perspective.
> 
> You are talking about moving ~5000 lines of legacy code back into 
> arch/x86/, for a total of *four* Voyager/Linux systems, which are 
> using _ancient_ 486/P5 era CPUs.
> 
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
> 
> You still have not given proper justification for doing that ...
> 
> Sorry to be the one to say 'no', but the reasons you gave so far 
> were not very convincing to me.
>  
> Anyway, you seem to be willing to maintain this code it out of tree. 
> If someone owns such an ancient Voyager box and wants to test a new 
> kernel then your tree is a good starting point for doing that. 
> There's really no pressing need to have this in mainline.

That argument is more than a little unfair, Ingo.  Voyager support used 
to be in mainline.

It got yanked, and now you are adding all sorts of barriers for its 
re-inclusion?

And out of curiosity, who reviewed and accepted the patch that broke 
Voyager's build?

Don't get hopping mad just because someone doesn't move at your warp 
speed.  Just mark it CONFIG_BROKEN and __move on__.

Taking my vendor hat OFF for a second, this sort of stuff just smacks 
"corporate Linux" to me.  What happened to the Linux community that 
encouraged enthusiasts who wanted to keep alive some obscure code in the 
kernel?

I think it will be a sad day when somebody, in an Ingo-like fit of 
cleaning, rm -rf's m68k, alpha, and the like.

I am not an x86 maintainer, of course, but it hardly seems likely that 
the existence of Voyager in the x86 tree is a huge, crushing, 
soul-sucking burden.

A world without dinosaur architectures is a world without fun :)

	Jeff





