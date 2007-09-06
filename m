Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbXIFMVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbXIFMVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXIFMVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:21:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37699 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753485AbXIFMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:21:42 -0400
Date: Thu, 6 Sep 2007 14:21:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070906122143.GM16016@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz> <200709061155.46667.vda.linux@googlemail.com> <20070906114044.GM475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070906114044.GM475@flower.upol.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 01:40:44PM +0200, Oleg Verych wrote:
> On Thu, Sep 06, 2007 at 11:55:46AM +0100, Denys Vlasenko wrote:
> []
> > > Give me example, please, why function must be non static if not used.
> > 
> > Where do you see I'm saying that they must be non-static?
> > I'm all for marking functions static. I just did it for aic7xxx.
> > 
> > > If usage requires kconfig tuning, then this is a better way to go,
> > 
> > We already do it, but we don't have enough developers to audit
> > every driver for every possible combination of config options.
> > As a result, there always be some amount of unused functions and data.
> > Using --gc-sections will discard that.
> 
> You've did a tool. Documenting this tool to have it available for
> testers/janitors/maintainers is a better way, than to have all that
> opinions/problems with merging-to-mainline.

There is no problem with his patch.

His patch improves the build process.

And there's no reason to hide this from the users.

> > > than to adopt yet another GNU/Luxury.
> > 
> > Actually, this is how linkers should have worked long ago.
> > Borland's Turbo Pascal was doing it ten+ years ago.
> > 
> > I don't understand why you are opposed to toolchain helping
> > humans to get optimized result. But it's fine with me.
> > I won't force anyone to select CONFIG_DISCARD_UNUSED_SECTIONS.
> 
> That's why. It's treating symptoms, isn't it?

There's nothing that requires treatment.

It's a matter of fact that the kernel takes advantages from some 
features of GNU binutils and GNU gcc that might not be available
in other versions of these tools.

Whether you like it or not - that's not going to change.

But don't continue arguing about something where you won't win with 
words - it's open source, so you can always create a fork of the Linux 
kernel that builds with whatever toolchain you want.

The only way you could convince other people from your point of view 
would be if your forked version of the kernel would contain advantages 
that convince many users to use your kernel rather than Linus' one.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

