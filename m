Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbYIGXZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbYIGXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYIGXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:25:48 -0400
Received: from xenotime.net ([66.160.160.81]:45566 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750823AbYIGXZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:25:48 -0400
Date: Sun, 7 Sep 2008 16:25:39 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: build issue #565 for v2.6.27-rc5 : undefined reference to
 `ei_interrupt' in hp-plus.c
In-Reply-To: <200809071519.09066.toralf.foerster@gmx.de>
Message-ID: <Pine.LNX.4.64.0809071623590.14467@shark.he.net>
References: <200809071519.09066.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-1757710931-1220829939=:14467"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-1757710931-1220829939=:14467
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 7 Sep 2008, Toralf F=F6rster wrote:

> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 7 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `hpp_open':
> hp-plus.c:(.text+0x1952a7): undefined reference to `ei_interrupt'
> hp-plus.c:(.text+0x195318): undefined reference to `ei_open'
> drivers/built-in.o: In function `hpp_close':
> hp-plus.c:(.text+0x1953fe): undefined reference to `ei_close'
> drivers/built-in.o: In function `hp_plus_probe':
> (.init.text+0x12013): undefined reference to `__alloc_ei_netdev'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> The build was made with :
> $>make randconfig; make clean; make
>=20
> Here's the config:

Hi,

hopefully this patch from last week fixes this build error, but
the patch needs to be merged....
  http://marc.info/?l=3Dlinux-next&m=3D122038632306156&w=3D2

--=20
~Randy
---1606286688-1757710931-1220829939=:14467--
