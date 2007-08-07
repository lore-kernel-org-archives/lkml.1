Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXHGLLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXHGLLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXHGLLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:11:46 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:59885 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbXHGLLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:11:45 -0400
Date: Tue, 7 Aug 2007 13:11:31 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Andreas Mohr <andi@lisas.de>
Cc: =?UTF-8?Q?Rafa=C5=82?= Bilski <rafalbilski@interia.pl>,
       David Edwards <powertop@dpe.lusars.net>, power@bughost.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
Message-ID: <20070807131131.163b09fc@laptop.hypervisor.org>
In-Reply-To: <20070806235752.1e6c5653@laptop.hypervisor.org>
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
	<46B79512.6090704@interia.pl>
	<20070806235752.1e6c5653@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_S2pIXm23yAW7Ja/STIvZ9Ed";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_S2pIXm23yAW7Ja/STIvZ9Ed
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Aug 2007 23:57:52 +0200 Udo A. Steinberg (UAS) wrote:

UAS> My guess is that newer revisions of VT8235 have HPET whereas older
UAS> revisions do not. I'll get an lspci dump from our box tomorrow.

Here is the lspci dump from our K7VT4A+ board, where HPET works.

00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host B=
ridge (rev 80)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 80)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 80)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 80)
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT82=
3x/A/C PIPC Bus Master IDE (rev 06)
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8=
237 AC97 Audio Controller (rev 50)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev =
74)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Ra=
deon 7000/VE]

00:11.0 0601: 1106:3177
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 77 31
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 00 78 00 00 00 00 00 0c 01 00 00 44 00 08 08
50: 81 1d 09 00 00 00 00 00 43 00 ff 01 00 00 04 08
60: 00 00 00 00 10 00 02 04 00 00 00 00 00 00 00 00
70: 49 18 77 31 00 00 00 00 00 00 00 00 10 00 00 00
80: 20 84 59 00 9a 10 00 00 01 08 00 00 04 18 00 00
90: 00 77 d8 00 b4 c5 08 00 10 92 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 04 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 04 08 c0 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 16 00 00 00 00 00 01 00 00 00

Cheers,

	- Udo

--Sig_S2pIXm23yAW7Ja/STIvZ9Ed
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGuFNknhRzXSM7nSkRAqpDAJ43gH9JEtaLpvVxFzow4JcPQ6N0nQCfZawj
D2psOYuPIw3Qgm0wg91csGI=
=/LXS
-----END PGP SIGNATURE-----

--Sig_S2pIXm23yAW7Ja/STIvZ9Ed--
