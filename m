Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXIEVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXIEVwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbXIEVwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:52:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32977 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756726AbXIEVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:52:02 -0400
Date: Wed, 5 Sep 2007 23:52:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070905215204.GK16016@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com> <E1ISxBz-00040p-EO@flower> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070905203438.GG475@flower.upol.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 10:34:38PM +0200, Oleg Verych wrote:
> On Wed, Sep 05, 2007 at 07:46:11PM +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 16:53, Oleg Verych wrote:
> > > * Wed, 5 Sep 2007 14:43:21 +0100
> > > * User-Agent: KMail/1.9.1
> > > >
> > > > Build system: section garbage collection for vmlinux
> > > 
> > > Maybe this is just a test suit to get finish with `make XYZ static`?
> > 
> > They are vaguely connected in a sense that unused function which is
> > not marked static doesn't generate gcc warning, but will be discarded
> > by --gc-sections. "make XYZ static" also tends to find them - you make
> > function static, you recompile the file, and gcc informs you that
> > the function is not used at all!
> > 
> > This happened to me when I did aic7xxx patches.
> > 
> > You may yse --print-gc-sections to see the list of discarded sections.
> 
> Anyway, this is gccism/binutilizm. That about other possible/future
> options?

The kernel requires GNU gcc and GNU binutils, and if you want to use 
other tools for building the kernel they have to be sufficiently 
compatible.

> Give me example, please, why function must be non static if not used.

s/not used/not used in this kernel configuration/

> If usage requires kconfig tuning, then this is a better way to go, than
> to adopt yet another GNU/Luxury.

The alternative would be to use an unmaintainable amount of #ifdef's.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

