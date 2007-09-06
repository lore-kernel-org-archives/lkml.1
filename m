Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXIFLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXIFLZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbXIFLZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:25:39 -0400
Received: from barikada.upol.cz ([158.194.242.200]:43308 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbXIFLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:25:38 -0400
Date: Thu, 6 Sep 2007 13:40:44 +0200
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Message-ID: <20070906114044.GM475@flower.upol.cz>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz> <200709061155.46667.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709061155.46667.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 11:55:46AM +0100, Denys Vlasenko wrote:
[]
> > Give me example, please, why function must be non static if not used.
> 
> Where do you see I'm saying that they must be non-static?
> I'm all for marking functions static. I just did it for aic7xxx.
> 
> > If usage requires kconfig tuning, then this is a better way to go,
> 
> We already do it, but we don't have enough developers to audit
> every driver for every possible combination of config options.
> As a result, there always be some amount of unused functions and data.
> Using --gc-sections will discard that.

You've did a tool. Documenting this tool to have it available for
testers/janitors/maintainers is a better way, than to have all that
opinions/problems with merging-to-mainline.

> > than to adopt yet another GNU/Luxury.
> 
> Actually, this is how linkers should have worked long ago.
> Borland's Turbo Pascal was doing it ten+ years ago.
> 
> I don't understand why you are opposed to toolchain helping
> humans to get optimized result. But it's fine with me.
> I won't force anyone to select CONFIG_DISCARD_UNUSED_SECTIONS.

That's why. It's treating symptoms, isn't it?
____
