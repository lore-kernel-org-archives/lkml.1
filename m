Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXJXMzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXJXMzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXJXMzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:55:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37335 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218AbXJXMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:55:04 -0400
Date: Wed, 24 Oct 2007 14:55:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface
Message-ID: <20071024125533.GE30533@stusta.de>
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <55615.simon.1193226629@5ec7c279.invalid>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 12:50:29PM +0100, Simon Arlott wrote:
> I currently have an LSM that only handles permissions for socket_bind
> and socket_listen, I load it and then "capability" as secondary on
> boot - but now I can't because the LSM framework is now just the LS
> framework.
> 
> Why can't this "static LSM" change be a Kconfig option?
> (I don't want to have to maintain my own reverted copy of security/,
> or compile this into the kernel because then I can't ever modify and
> reload it without rebooting.)

Let's start with the more important questions:

Did you submit your LSM for inclusion into the kernel?

If yes, why wasn't it accepted?
If no, why not?

> Simon Arlott

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

