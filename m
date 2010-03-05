Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0CEQqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:46:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989Ab0CEQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:46:06 -0500
Date: Fri, 5 Mar 2010 08:44:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, daniel@fooishbar.org,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305162327.084d4038@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003050832250.3788@localhost.localdomain>
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net> <20100305160217.663413eb@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003050810140.3788@localhost.localdomain>
 <20100305162327.084d4038@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Alan Cox wrote:

> > So the watershed moment was _never_ the "Linus merged it". The watershed 
> > moment was always "Fedora started shipping it". That's when the problems 
> > with a standard upstream kernel started.
> > 
> > Why is that so hard for people to understand?
> 
> So why are you screaming at the DRM and Nouveau people about the
> breakage ? That's the bit I really don't understand.

Umm. You _really_ haven't been following, have you?

Look at who I screamed at. Dave Airlie. The guy who works for Red Hat. The 
guy who is, as far as I know, effectively in charge of that whole 
integration. Yeah, I realize that there are other people (Kyle?) involved, 
and maybe Dave isn't as central as I think he is, but I learnt from last 
time that the nouveau guys don't seem to care.

And I would like to say that yes, Dave really helped me. He got me a 
working setup again. I thank you, Dave. It means I don't have to revert 
the thing, and we can hopefully make progress.

That said, I do think that the Fedora people _should_ have been the ones 
to catch this as a problem, and pushed back a bit on the Nouveau people 
even before it got to me. For all the reasons I've mentioned.

Even if you need to change the interface, I've actually looked at the 
patch in question (have you, Alan?), and I got the very strong feeling 
that it _could_ have been done without breaking compatibility so 
completely and utterly, and making it so apparently intentionally hard to 
have a driver that can handle both the old and the new.

IOW, maybe it would have required a new nouveau_drv etc, but with a 
slightly less hack-and-slash approach, maybe the new one could have 
supported the old interfaces enough to at least limp along.

For example, breaking DRM so that 3D doesn't work, but you still get basic 
2D acceleration - that's _way_ more acceptable, and is likely to need a 
much smaller subset of the whole DRI functionality. It looks like nobody 
even tried.

			Linus
