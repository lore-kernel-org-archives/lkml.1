Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYDXOwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYDXOwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYDXOwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:52:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36012 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbYDXOwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:52:45 -0400
Date: Thu, 24 Apr 2008 17:51:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080424145159.GC2559@cs181133002.pp.htv.fi>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422081211.e85989ec.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080422081211.e85989ec.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:12:11AM -0700, Randy Dunlap wrote:
> On Tue, 22 Apr 2008 13:13:39 +0100 Will Newton wrote:
> 
> > Hi,
> > 
> > This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
> > architectures that support the sysfs(2) system call. At the moment
> > that's everybody but blackfin, but future architectures may want to
> > save the (admittedly small) code size that it adds to the kernel as
> > well.
> > 
> > (patch attached as well as inline because gmail seems to mangle my whitespace)
> > 
> > ---
> > >From d0746366e8ccb5fbaa6c9945540cecbe0c421222 Mon Sep 17 00:00:00 2001
> > From: Will Newton <will.newton@imgtec.com>
> > Date: Tue, 22 Apr 2008 12:57:03 +0100
> > Subject: [PATCH] Introduce __ARCH_WANT_SYS_SYSFS.
> > 
> > Signed-off-by: Will Newton <will.newton@imgtec.com>
> > 
> > All arches that want the sysfs(2) system call should define this symbol.
> > Arches such as blackfin that do not implement the system call don't compile
> > the code and save some small amount of space.
> 
> Is there any reason that this couldn't (and shouldn't) be done
> in the Kconfig space and done as documented in
> Documentation/kbuild/kconfig-language.txt ?
>...

Moving it to Kconfig makes sense for stuff where the placement is 
arbitrary.

But in this case having everything in one file is better than splitting 
the information between the header and Kconfig.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

