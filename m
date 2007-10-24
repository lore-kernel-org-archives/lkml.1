Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXJXWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXJXWbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXJXWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:30:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40165 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753903AbXJXWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:30:56 -0400
Date: Thu, 25 Oct 2007 00:31:24 +0200
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
	static interface)
Message-ID: <20071024223124.GI30533@stusta.de>
References: <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471F8AC5.9080300@simon.arlott.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 07:11:17PM +0100, Simon Arlott wrote:
> On 24/10/07 13:55, Adrian Bunk wrote:
> > On Wed, Oct 24, 2007 at 12:50:29PM +0100, Simon Arlott wrote:
> >> I currently have an LSM that only handles permissions for socket_bind
> >> and socket_listen, I load it and then "capability" as secondary on
> >> boot - but now I can't because the LSM framework is now just the LS
> >> framework.
> >> 
> >> Why can't this "static LSM" change be a Kconfig option?
> >> (I don't want to have to maintain my own reverted copy of security/,
> >> or compile this into the kernel because then I can't ever modify and
> >> reload it without rebooting.)
> > 
> > Let's start with the more important questions:
> > 
> > Did you submit your LSM for inclusion into the kernel?
> 
> No, because the interface for configuring it would be rejected... I have 
> a /proc file which I write a binary configuration file to. This works 
> fine for me but it would take a lot of work to write a proper interface 
> - which I'm still not sure how to do*.
>...

Generally, the goal is to get external modules included into the kernel.

You want to be able to have this functionality and you do not want to 
use SELinux for it.

But instead of working on getting your code into the kernel you are 
requesting that an API making it easier for you to maintain it 
externally comes back.

There are other points in this thread that might or might not warrant 
making LSM modular again, but even though it might sound harsh breaking 
external modules and thereby making people aware that their code should 
get into the kernel is IMHO a positive point.

> Simon Arlott

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

