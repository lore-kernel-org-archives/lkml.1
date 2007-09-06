Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbXIFUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbXIFUjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXIFUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:39:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44444 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757637AbXIFUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:39:28 -0400
Date: Thu, 6 Sep 2007 22:39:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070906203931.GE4480@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz> <200709061155.46667.vda.linux@googlemail.com> <20070906114044.GM475@flower.upol.cz> <20070906122143.GM16016@stusta.de> <20070906204349.GO475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070906204349.GO475@flower.upol.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 10:43:49PM +0200, Oleg Verych wrote:
> On Thu, Sep 06, 2007 at 02:21:43PM +0200, Adrian Bunk wrote:
> []
> > > You've did a tool. Documenting this tool to have it available for
> > > testers/janitors/maintainers is a better way, than to have all that
> > > opinions/problems with merging-to-mainline.
> > 
> > There is no problem with his patch.
> > 
> > His patch improves the build process.
> 
> I would like to know timing, btw. Size, especially shown 1%, doesn't
> matter if link time increased dramatically. `Allyes' config, when i
> had fast and rammish machine was terrible thing (last winter). If 32
> cores/cpus is will of author, then i'm even more suspicious.

For non-developers size and speed of the kernel matter much more than 
compile time.

When you go towards embedded systems with limited resources a 1% size 
decrease would often be worth it even if it would (hypothetically) 
increase the compile time by a factor of 10.

>...
> > > > I don't understand why you are opposed to toolchain helping
> > > > humans to get optimized result. But it's fine with me.
> > > > I won't force anyone to select CONFIG_DISCARD_UNUSED_SECTIONS.
> > > 
> > > That's why. It's treating symptoms, isn't it?
> > 
> > There's nothing that requires treatment.
> 
> [Help for] The developers/contributors of those drivers, no?
>...

They did everything right.

You should better try to understand the problem first before behaving as 
if you knew everything better than everyone else...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

