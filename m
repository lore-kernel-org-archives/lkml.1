Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYJ2N1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYJ2N1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYJ2N1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:27:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYJ2N1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:27:23 -0400
Date: Wed, 29 Oct 2008 06:27:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: =?UTF-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, klausman@gentoo.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ALPHA] 2.6.28-rc fails to compile
Message-ID: <20081029062741.7400e330@infradead.org>
In-Reply-To: <20081029100356.GA28224@cs181140183.pp.htv.fi>
References: <49083361.5060907@gentoo.org>
	<20081029100356.GA28224@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 12:03:56 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Oct 29, 2008 at 10:56:49AM +0100, Raúl Porcel wrote:
> > Hi,
> > 
> > I guess the git bisect says everything, but if you need more info,
> > please say so.
> 
> Please send your .config
> 
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   HOSTCC  scripts/basic/fixdep
> >   HOSTCC  scripts/basic/docproc
> >   HOSTCC  scripts/basic/hash
> >   CC      kernel/bounds.s
> >   GEN     include/linux/bounds.h
> >   CC      arch/alpha/kernel/asm-offsets.s
> > In file included from
> > /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/core_tsun
> > ami.h:5,
> >                  from
> > /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:232,
> >                  from arch/alpha/kernel/asm-offsets.c:12:
> > include/linux/pci.h: In function 'pci_ioremap_bar':
> > include/linux/pci.h:1148: error: implicit declaration of function
> > 'ioremap_nocac
> > he'
> > include/linux/pci.h:1149: warning: return makes pointer from integer
> > without a c
> > ast
> > In file included from arch/alpha/kernel/asm-offsets.c:12:
> > /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h: At top level:
> > /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:300: error:
> > conflicting ty
> > pes for 'ioremap_nocache'
> > include/linux/pci.h:1148: error: previous implicit declaration of
> > 'ioremap_nocac
> > he' was here
> > make[1]: *** [arch/alpha/kernel/asm-offsets.s] Error 1
> > make: *** [prepare0] Error 2
> > 

Andrew has a patch for this in his tree for a while... I was assuming
he'd do a patchdump to Linus late in -rc1 but it seems not to have
happened..
