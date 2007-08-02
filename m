Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbXHBQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbXHBQC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbXHBQCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:02:22 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:33415 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817AbXHBQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:02:21 -0400
Message-ID: <46B1FFFB.6040209@interia.pl>
Date: Thu, 02 Aug 2007 18:02:03 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
Cc: trivial@kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtdsuper: licensce = GPL
References: <46B0D1F7.9090805@interia.pl> <alpine.LFD.0.999.0708020318070.8258@enigma.security.iitk.ac.in> <46B18551.2020809@interia.pl> <alpine.LFD.0.999.0708021309430.8258@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708021309430.8258@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 2441eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You should apply -rcN or -gitX patches on the previous Linus' kernel
> (2.6.x) and not the 2.6.x.y "-stable" ones -- those are a "parallel" tree.
Done.
> Hmm, you've got mtdpart build separately as well. Could you redo as per
> what I suggested above (take 2.6.22, apply -rc1, then -rc1-git3) and then
> rebuild after "make oldconfig" ... and let us know if you still end up
> with these modules?
This time I used Linux-2.6.23-rc1-git11 with config for my desktop plus 
MTD selected as <M>. Previous config was for my "router". Let me know 
if You need "desktop" config too.

  CC [M]  drivers/mtd/mtdcore.o
  CC [M]  drivers/mtd/mtdsuper.o
  CC [M]  drivers/mtd/mtdchar.o
  CC [M]  drivers/mtd/mtd_blkdevs.o
  CC [M]  drivers/mtd/mtdblock.o
[...]
  CC      drivers/mtd/chips/chipreg.mod.o
  LD [M]  drivers/mtd/chips/chipreg.ko
  CC      drivers/mtd/devices/block2mtd.mod.o
  LD [M]  drivers/mtd/devices/block2mtd.ko
  CC      drivers/mtd/mtd_blkdevs.mod.o
  LD [M]  drivers/mtd/mtd_blkdevs.ko
  CC      drivers/mtd/mtdblock.mod.o
  LD [M]  drivers/mtd/mtdblock.ko
  CC      drivers/mtd/mtdchar.mod.o
  LD [M]  drivers/mtd/mtdchar.ko
  CC      drivers/mtd/mtdcore.mod.o
  LD [M]  drivers/mtd/mtdcore.ko
  CC      drivers/mtd/mtdsuper.mod.o
  LD [M]  drivers/mtd/mtdsuper.ko

% ls *.ko
mtd_blkdevs.ko  mtdblock.ko  mtdchar.ko  mtdcore.ko  mtdsuper.ko

> Could also be a make/toolchain issue at your end,
> for all I know.
I'm using "Arch Linux" now.
% make -v
GNU Make 3.81
[...]
This program built for i686-pc-linux-gnu

% gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../configure --prefix=/usr --enable-shared --enable-languages=c,c++,objc --enable-threads=posix --enable-__cxa_atexit --disable-multilib --libdir=/usr/lib --libexecdir=/usr/lib --enable-clocale=gnu --disable-libstdcxx-pch --with-tune=generic
Thread model: posix
gcc version 4.2.1 20070704 (prerelease)

% ld -v
GNU ld version 2.17

> Satyam
Rafa³


----------------------------------------------------------------------
Jak najszybciej dostac sie na wymarzona plaze?
Znajdz trase ekspresowa 

>>>http://link.interia.pl/f1b0d

