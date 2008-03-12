Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYCLXy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYCLXy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYCLXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:54:48 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47180 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYCLXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:54:47 -0400
X-Sasl-enc: 9mUbPAEwjpxnUurt5gO9BEksSQdYLD3OxKnbmDCGZ0dw 1205366085
Message-ID: <47D86D43.2060108@imap.cc>
Date: Thu, 13 Mar 2008 00:54:43 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD70819E4BA06696143AEEBA6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD70819E4BA06696143AEEBA6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.03.2008 09:14 schrieb Andrew Morton:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc=
5/2.6.25-rc5-mm1/

This still complains during startup:

<6>[    0.063442] Checking 'hlt' instruction... OK.
<0>[    0.068233] BUG: spinlock bad magic on CPU#0, swapper/0
<0>[    0.068996]  lock: c2c19380, .magic: 00000000, .owner: swapper/0, .=
owner_cpu: 0
<4>[    0.069227] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testin=
g #1
<4>[    0.069369]  [spin_bug+124/135] spin_bug+0x7c/0x87
<4>[    0.069563]  [_raw_spin_unlock+25/113] _raw_spin_unlock+0x19/0x71
<4>[    0.069752]  [_spin_unlock+29/60] _spin_unlock+0x1d/0x3c
<4>[    0.069941]  [mnt_want_write+98/136] mnt_want_write+0x62/0x88
<4>[    0.070131]  [sys_mkdirat+134/214] sys_mkdirat+0x86/0xd6
<4>[    0.070322]  [clean_path+22/74] ? clean_path+0x16/0x4a
<4>[    0.070558]  [kfree+216/236] ? kfree+0xd8/0xec
<4>[    0.070793]  [sys_mkdir+16/18] sys_mkdir+0x10/0x12
<4>[    0.070995]  [do_name+274/435] do_name+0x112/0x1b3
<4>[    0.071184]  [write_buffer+29/44] write_buffer+0x1d/0x2c
<4>[    0.071371]  [flush_window+100/179] flush_window+0x64/0xb3
<4>[    0.071558]  [unpack_to_rootfs+1580/2233] unpack_to_rootfs+0x62c/0x=
8b9
<4>[    0.071747]  [populate_rootfs+32/265] populate_rootfs+0x20/0x109
<4>[    0.071995]  [alternative_instructions+339/344] ? alternative_instr=
uctions+0x153/0x158
<4>[    0.072235]  [start_kernel+835/853] start_kernel+0x343/0x355
<4>[    0.072422]  [i386_start_kernel+8/10] i386_start_kernel+0x8/0xa
<4>[    0.072610]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
<6>[    0.072808] Unpacking initramfs... done

System comes up fine, though. Not sure whom to CC.
Machine's a dual-core Pentium D running a 32 bit kernel.
Let me know if you want me to provide more information or test anything.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD70819E4BA06696143AEEBA6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2G1DMdB4Whm86/kRAp7VAJ48XEV4rUzh1MIOjrYAzhbLrKw3eACdF5Ll
ynahkdZWOE+tuFIRM5iIEME=
=uvHg
-----END PGP SIGNATURE-----

--------------enigD70819E4BA06696143AEEBA6--
