Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbXIETb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbXIETb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbXIETbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:31:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36799 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755044AbXIETbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:31:51 -0400
Date: Wed, 5 Sep 2007 21:31:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Daniel Walker <dwalker@mvista.com>, sam@ravnborg.org,
       kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070905193150.GI16016@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051937.04014.vda.linux@googlemail.com> <1189017519.4442.24.camel@imap.mvista.com> <200709052014.12653.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200709052014.12653.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 08:14:12PM +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > > You version doesn't work with CONFIG_MODULES right?
> > > 
> > > It works with CONFIG_MODULES.
> > 
> > Really? Take a look at this version,
> > 
> > http://lkml.org/lkml/2006/6/4/169
> > 
> > Marcello had to implement a two pass build to add back symbol used in
> > modules which got removed from the main kernel.. You don't appear to do
> > that. Marcelo also claims better size reduction than you.
> 
> This will discard EXPORT_SYMBOLs potentially used by
> out-of-tree modules.
> 
> I also saw ~10% size reductions, but then at run-time test modules
> failed to load, they didn't find needed symbols.
> 
> OTOH if I know that I am not going to be using such modules,
> then this can be done. Will require another CONFIG_xxx, though.

One point to keep in mind is that the space penalty of CONFIG_MODULES=y 
is so big that CONFIG_MODULES=n is actually the most interesting case 
for small systems that really need small kernels.

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

