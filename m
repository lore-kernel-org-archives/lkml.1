Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZBQKqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZBQKqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZBQKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:46:00 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:1998 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZBQKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:45:59 -0500
Message-ID: <499A9560.1090209@imap.cc>
Date: Tue, 17 Feb 2009 11:45:52 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28.[45] boot failure: request_module: runaway loop modprobe
 binfmt-464c
References: <499A7EE2.50108@imap.cc> <ac3eb2510902170201t696df348ka167c12ad5819494@mail.gmail.com>
In-Reply-To: <ac3eb2510902170201t696df348ka167c12ad5819494@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA09670A1027024FDC2FA6EAC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA09670A1027024FDC2FA6EAC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Feb 2009 11:01:51 +0100, Kay Sievers wrote:
> On Tue, Feb 17, 2009 at 10:09, Tilman Schmidt <tilman@imap.cc> wrote:
>> My workhorse machine (Pentium D 940, Intel DG965QF board,
>> mirrored SATA disks), which runs fine with kernel:
>> ts@xenon:~> uname -a
>> Linux xenon 2.6.28.3-testing #1 SMP PREEMPT Mon Feb 2 23:32:07 CET 200=
9 i686 i686 i386 GNU/Linux
>> fails to come up with an identically configured 2.6.28.4 or 2.6.28.5
>> kernel. [...]
>=20
> Are you sure, that you don't have a 32/64 bit mismatch between the
> kernel and userspace? Like you miss 32-bit emulation in a 64-bit
> kernel, or your modprobe is 64-bit and you are trying to run it on a
> 32-bit kernel?

Pretty sure. Although running on a 64 bit capable processor, this
is a pure 32 bit installation:

ts@xenon:~> file /sbin/modprobe
/sbin/modprobe: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),=
 for GNU/Linux 2.6.4, dynamically linked (uses shared libs), stripped
ts@xenon:~> uname -a
Linux xenon 2.6.28.3-testing #1 SMP PREEMPT Mon Feb 2 23:32:07 CET 2009 i=
686 i686 i386 GNU/Linux
ts@xenon:~> diff kernel/linux-2.6.28.{3,5}-work/.config
3,4c3,4
< # Linux kernel version: 2.6.28.3
< # Mon Feb  2 22:41:42 2009
---
> # Linux kernel version: 2.6.28.5
> # Sat Feb 14 00:06:09 2009
ts@xenon:~> file /boot/vmlinuz-2.6.28.*
/boot/vmlinuz-2.6.28.3-testing: Linux/x86 Kernel, Setup Version 0x209, bz=
Image, Version 2.6.28.3, RO-rootFS, swap_dev 0x2, Normal VGA
/boot/vmlinuz-2.6.28.5-testing: Linux/x86 Kernel, Setup Version 0x209, bz=
Image, Version 2.6.28.5, RO-rootFS, swap_dev 0x2, Normal VGA
ts@xenon:~>

The first one of these two kernels runs fine, the second one hangs.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigA09670A1027024FDC2FA6EAC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJmpVhQ3+did9BuFsRAsC5AJ9UNjb2DqoZrwqBBN9E8Mdcs9DLDgCfbs9f
xLUVrAgSXazBM9/DvGg/C7A=
=Xrv/
-----END PGP SIGNATURE-----

--------------enigA09670A1027024FDC2FA6EAC--
