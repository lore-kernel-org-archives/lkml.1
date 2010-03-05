Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0CEQ0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:26:43 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:52268 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753319Ab0CEQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:26:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pQpBLiVAYe7iQ7PH3Jjml7S3vvr/yP4Zg3YzPxJB3wu3h/f34N35e2TdIGmreOQqiQkMpdR5Yw7AZnOFNrCSaOn2gJxN3qpB8Fas0BUqgnFRkjcvx2FamUpEr0uliuSm;
Date: Fri, 5 Mar 2010 08:26:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
Message-ID: <20100305082652.43534ef4@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
References: <20100304105624.70fe845e@jbarnes-piketon>
	<alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	<21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	<alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	<21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	<alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	<1267748927.3496.6.camel@nisroch>
	<20100305064955.GA6453@elte.hu>
	<84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
	<20100305074407.GC19703@elte.hu>
	<20100305100030.GA4970@Pilar.aei.mpg.de>
	<alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010 07:53:46 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 5 Mar 2010, Carlos R. Mafra wrote:
> > 
> > Whereas everytime I wanted to do that with Xorg it was such a pain that
> > I want to keep away from that mess.
> 
> Actually, take it from me: Xorg is _pleasant_ to test these days.
> 
> Ok, so that's partly compared to the mess it _used_ to be, but it's really 
> night and day. The whole build system was so incredibly baroque and heavy 
> that you really had to understand it deeply if you wanted to do anything 
> fancy.
> 
> And the non-fancy alternative was to just build the whole thing, which 
> took _hours_ even on fast machines because the build system overhead was 
> near-infinite (I dunno, maybe parallel builds could be made to work, but 
> it took more brain-power than I could ever put into it).
> 
> These days, there's a few dependencies you need to know about (I do agree 
> that from a user perspective the thing might have been made a bit _too_ 
> modular) but they are generally fairly trivial, and there are scripts to 
> download all the drivers and misc utilities needed.

Just FYI for those following this thread; testing the server and 3D
drivers really isn't too much trouble these days, you can even install
everything into a separate path (I usually choose /opt-gfx-test); you
just need to build libdrm, mesa, xserver and your video driver (along
with an input driver or tw) in that order.  Then just startx
-- /opt/gfx-test/bin/Xorg and put something reasonable in .xinitrc.

Full instructions at http://wiki.x.org/wiki/Development/BuildingX.

--
Jesse Barnes, Intel Open Source Technology Center
