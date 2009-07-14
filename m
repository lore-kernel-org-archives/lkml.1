Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGNRXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGNRXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZGNRXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:23:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbZGNRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:23:19 -0400
Subject: Re: binary ftrace buffer format
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1247520189.4071.4.camel@johannes.local>
References: <1247520189.4071.4.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ajMeK1yXFZr3UOjk3bAL"
Date: Tue, 14 Jul 2009 19:22:47 +0200
Message-Id: <1247592167.7178.25.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ajMeK1yXFZr3UOjk3bAL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So, I've gotten this far, manually:

This was on a powerpc 64-bit (big endian) machine, the contents of
per_cpu/trace_pipe_raw:

00000000  00 00 02 24 15 cd b4 a0  00 00 00 00 00 00 0f f0	page header: tim=
e 2354.007880864, 4080 bytes
00000010  00 00 00 00						item header: type_len =3D=3D 0, time offset =3D =
0
                      00 00 00 94				item length: 148 bytes
                                   00 82			event ID 130
                                         11 02 00 00 00 00
00000020  00 00 00 00 00 00 00 00  c0 00 00 01 03 ca 1a 00
00000030  00 1a 70 00 00 00 01 00  00 80 39 e4 01 00 00 00
00000040  00 00 00 00 00 00 01 09  01 00 7c 10 80 00 ec 0f
00000050  80 00 00 00 00 00 01 00  00 00 ff ff ff ff 1a ff
00000060  ff ff 02 ff ff ff 20 34  00 00 e2 34 00 00 c4 ca
00000070  ff ff 94 c9 ff ff 66 f3  ff ff e6 f2 ff ff 00 00
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
00000090  00 00 00 00 00 00 ff ff  ff ff ff ff ff ff ff ff
000000a0  ff ff 00 00
                      00 00 00 00				item header: type_len =3D=3D 0, time o=
ffset =3D=3D 0
                                   88 78 3d 40			item length???
                                               00 82		event ID 130
                                                     11 02

at which point it stops making sense. What's with that item length? Can
anyone help?

johannes

--=-ajMeK1yXFZr3UOjk3bAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXL7kAAoJEODzc/N7+QmafxAP/0kF1LelhAkv6SRagY7BDzKz
EEThUzFtvFK7kW/PGl8GhW4SDYyzCKt5xdjXVC50yJ1WZkpMB3hlxjFI0Ah3mUQS
JcYUbXnX8bV7qBmhY4M2l20RG/hXW2+xSx79ZfOWGyVwj6i+zTYFPpe8BYyI8EZU
cgxiYxLzj9sB09TqLgHYCr3hvUopJclu5AOHxCzZY2bKWdTEzAyx8uQvRUlPB1+r
d03fyS5vUbYdS+76Uma76QoFs3xWbMTKYz+nghgDg41s1c0BcDLjmCh+FQQ7mnRs
tAGM8Vnkc8SMXxdjDOe/8Yl8mqygXQV3LyHRec2qmgpgf7KzzwGTRsX58uT/C0mX
8L8Ihwac9J6Gw9REB0X5w5ITk7aqmWF8VeOkBgY4vbBHxpCd8fxb+qHUT3g9opDd
1gPR3p1Aay/ffdzsMnCIDKsdDADjhnQbEsmkhCyBzbmHMgp+1FjeD7CveEvc3Esk
OtDRGr6wDjpE3sFNrCKis6PRDUYmsh3TR5hN8dvkTdF4wYz6hh3asgY3mMttGxP4
nvHa+6duXh8Z+/UYG23L7wteO1j+JpfyPTc5Hbqc9l9EIJiJoLglEyzP8hBpt1fK
i5R59b46HVXOZorf+bQc3Nd4p7PgQSnExvGWROiCSET1GGW2LBQy9o1CQFr7CYou
6LOyiCyavU70VkV4xwp3
=SZAG
-----END PGP SIGNATURE-----

--=-ajMeK1yXFZr3UOjk3bAL--

