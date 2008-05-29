Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYE2TVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYE2TVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYE2TVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:21:24 -0400
Received: from xenotime.net ([66.160.160.81]:46562 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753579AbYE2TVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:21:24 -0400
Date: Thu, 29 May 2008 12:21:19 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #509 for v2.6.26-rc4-27-g0a2ce2f :undefined reference
 to `xquad_portio'
In-Reply-To: <200805292013.40587.toralf.foerster@gmx.de>
Message-ID: <Pine.LNX.4.64.0805291219040.7193@shark.he.net>
References: <200805292013.40587.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-124469728-1212088879=:7193"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-124469728-1212088879=:7193
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 29 May 2008, Toralf F=F6rster wrote:

> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `setup_portio_remap':
> /home/tfoerste/devel/linux-2.6/include/asm-x86/mach-numaq/mach_apic.h:132=
: undefined reference to `xquad_portio'
> arch/x86/kernel/built-in.o: In function `MP_bus_info':
> /home/tfoerste/devel/linux-2.6/arch/x86/kernel/mpparse.c:114: undefined r=
eference to `mpc_oem_bus_info'
> /home/tfoerste/devel/linux-2.6/arch/x86/kernel/mpparse.c:135: undefined r=
eference to `mpc_oem_pci_bus'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> The build was made with :
> $>make randconfig; make clean; make
>=20
> Here's the config:

[snip]

Yes, this is a longstanding build problem.  There was some
discussion about removing NUMAQ support from the kernel since the
machines are probably gone or dead, but I suppose that there was
no decision...

--=20
~Randy
---1606286688-124469728-1212088879=:7193--
