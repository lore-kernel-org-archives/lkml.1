Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXBOQBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXBOQBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbXBOQBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:01:39 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2549 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbXBOQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:01:38 -0500
Message-ID: <45D483D7.2040609@imap.cc>
Date: Thu, 15 Feb 2007 17:01:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA3785E2C2E1410C0B6F73915"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA3785E2C2E1410C0B6F73915
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Trying to build 2.6.20-mm1 on i386 with C=3D1, sparse 0.2 chokes
on arch/i386/kernel/i8253.c:

  CHECK   arch/i386/kernel/i8253.c
linux/marker.h: No such file or directory
include/linux/jiffies.h:18:5: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:20:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:22:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:24:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:26:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:28:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:30:7: warning: undefined preprocessor identifier =
'CONFIG_HZ'
include/linux/jiffies.h:33:3: error: You lose.
include/linux/jiffies.h:225:5: error: bad constant expression
include/asm/module.h:64:2: error: unknown processor family
include/asm/processor.h:82:30: error: undefined identifier 'CONFIG_X86_L1=
_CACHE_SHIFT'
include/asm/processor.h:82:30: error: bad constant expression type
arch/i386/kernel/i8253.c:120:16: error: Expected ; at end of declaration
arch/i386/kernel/i8253.c:120:16: error: got pit_read
arch/i386/kernel/i8253.c:128:2: error: Trying to use reserved word 'do' a=
s identifier
arch/i386/kernel/i8253.c:128:2: error: Expected ; at end of declaration
arch/i386/kernel/i8253.c:128:2: error: got {
[loads of similar messages omitted ...]
arch/i386/kernel/i8253.c:195:2: error: undefined identifier 'clocksource_=
pit'
arch/i386/kernel/i8253.c:196:9: error: undefined identifier 'clocksource_=
register'
arch/i386/kernel/i8253.c:41:7: error: Expected constant expression in cas=
e statement
arch/i386/kernel/i8253.c:50:7: error: Expected constant expression in cas=
e statement
arch/i386/kernel/i8253.c:51:7: error: Expected constant expression in cas=
e statement
arch/i386/kernel/i8253.c:52:7: error: Expected constant expression in cas=
e statement
/bin/sh: line 1: 18990 Speicherzugriffsfehler  /home/ts/kernel/sparse-0.2=
/sparse -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise -D__i3=
86__ -nostd
inc -isystem /usr/lib/gcc/i586-suse-linux/4.0.2/include -Wp,-MD,arch/i386=
/kernel/.i8253.o.d -nostdinc -isystem /usr/lib/gcc/i586-suse-linux/4.0.2/=
include -D_
_KERNEL__ -Iinclude -include include/linux/autoconf.h -include linux/mark=
er.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasin=
g -fno-comm
on -Os -pipe -msoft-float -mregparm=3D3 -mpreferred-stack-boundary=3D2 -m=
arch=3Di686 -mtune=3Dpentium3 -ffreestanding -maccumulate-outgoing-args -=
DCONFIG_AS_CFI=3D1 -I
include/asm-i386/mach-default -fno-omit-frame-pointer -fno-optimize-sibli=
ng-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -D"KBUILD_STR=
(s)=3D#s" -D"
KBUILD_BASENAME=3DKBUILD_STR(i8253)" -D"KBUILD_MODNAME=3DKBUILD_STR(i8253=
)" arch/i386/kernel/i8253.c
make[1]: *** [arch/i386/kernel/i8253.o] Fehler 139
make: *** [arch/i386/kernel] Fehler 2

gcc compiles it without a single complaint, though.

HTH

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigA3785E2C2E1410C0B6F73915
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF1IPXMdB4Whm86/kRAqxlAJ4vB+lq6p5secZZcaYQOJ+K6i22PwCfR4Rj
iJhabDMTpPQePCQb22FRAhg=
=zFHn
-----END PGP SIGNATURE-----

--------------enigA3785E2C2E1410C0B6F73915--
