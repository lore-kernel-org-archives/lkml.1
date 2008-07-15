Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYGOOXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYGOOXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYGOOXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:23:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52272 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbYGOOXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:23:46 -0400
Date: Tue, 15 Jul 2008 17:23:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: binutils 2.18.50.0.8 frv build error
Message-ID: <20080715142341.GF24533@cs181140183.pp.htv.fi>
References: <20080715121327.GA24533@cs181140183.pp.htv.fi> <20080715132005.GA6517@lucon.org> <20080715134747.GD24533@cs181140183.pp.htv.fi> <20080715140040.GA8580@lucon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080715140040.GA8580@lucon.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:00:40AM -0700, H.J. Lu wrote:
> On Tue, Jul 15, 2008 at 04:47:47PM +0300, Adrian Bunk wrote:
>...
> > I did an "frv-linux-objdump  -Dx" on the init/mounts.o files generated 
> > with both binutils versions, and the diff is:
> > 
> > 
> > --- working	2008-07-15 16:34:49.000000000 +0300
> > +++ broken	2008-07-15 16:34:40.000000000 +0300
> >  architecture: fr450, flags 0x00000011:
> >  HAS_RELOC, HAS_SYMS
> >  start address 0x00000000
> > -private flags = 0x800020d: -mcpu=fr450 -mgpr-32 -msoft-float non-pic relocations
> > +private flags = 0x800030d: -mcpu=fr450 -mgpr-32 -msoft-float -fpic non-pic relocations
> >  
> 
> Are you saying "ld -r init/do_mounts.o" changed private flags? If
> yes, please open a bug report at

It seems so.

> http://www.sourceware.org/bugzilla/
> 
> with the original init/do_mounts.o.

Done, it's #6747.

> H.J.

Thanks for your help
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

