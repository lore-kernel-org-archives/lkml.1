Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYEDR5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYEDR5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYEDR4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:56:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11105 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYEDR4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:56:54 -0400
Date: Sun, 4 May 2008 10:56:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #487 for v2.6.26-rc1-6-gafa26be :undefined
 reference to `es7000_plat'
Message-Id: <20080504105638.435b2d63.randy.dunlap@oracle.com>
In-Reply-To: <200805041535.55503.toralf.foerster@gmx.de>
References: <200805041535.55503.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 15:35:52 +0200 Toralf Förster wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 3 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/mach-generic/built-in.o: In function `es7000_rename_gsi':
> es7000plat.c:(.text+0xb52): undefined reference to `es7000_plat'
> arch/x86/mach-generic/built-in.o: In function `setup_unisys':
> (.init.text+0x206): undefined reference to `es7000_plat'
> arch/x86/mach-generic/built-in.o: In function `setup_unisys':
> (.init.text+0x212): undefined reference to `es7000_plat'
> arch/x86/mach-generic/built-in.o: In function `parse_unisys_oem':
> (.init.text+0x308): undefined reference to `es7000_plat'
> arch/x86/mach-generic/built-in.o: In function `parse_unisys_oem':
> (.init.text+0x318): undefined reference to `es7000_plat'
> arch/x86/mach-generic/built-in.o:(.init.text+0x32f): more undefined references to `es7000_plat' follow
> make: *** [.tmp_vmlinux1] Error 1

Patch is here:
http://lkml.org/lkml/2008/5/3/143

---
~Randy
