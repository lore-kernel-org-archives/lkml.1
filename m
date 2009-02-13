Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZBMJ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZBMJ6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZBMJ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:58:43 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:57692 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZBMJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:58:43 -0500
Date: Fri, 13 Feb 2009 10:58:40 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Make printk() output better readable
Message-ID: <20090213095840.GA17295@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00211-g37bed90 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey devs,

When reading current dmesg, I notice that some messages have the
structure

 Introduction:
   <location>: <text>

Example:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[...]

I also see

 <location>: <text>

Example:

[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[...]

Then, most of the stuff is simply

 <text>

[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106


The first two blocks are somehow readable, the <text> only
is a bit painful to read. I personally would prefer to have
at least <location> (which may also be driver, hardware location, etc)
before each line, if it's not of type 1 (introduction + indent).

I think currently it is totally inconsistent, as seen, one
of the worst cases with TCP, here:

[    0.355604] NET: Registered protocol family 2
[    0.402669] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.403216] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.404925] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.405538] TCP: Hash tables configured (established 262144 bind 65536)
[    0.405642] TCP reno registered

What do you think about it?

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmVRFAACgkQuL75KpiFGIyqYgCg4eK5peBOG7mE5w2u/4nujnNU
XvEAoLbK28jQeQVEH1jQx+jl+LMp7siR
=2kAA
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
