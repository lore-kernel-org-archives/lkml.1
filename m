Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIZPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIZPKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZPKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:10:44 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYIZPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:10:43 -0400
Subject: Re: bad DMAR interaction with iwlagn and SATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Andres Freund <andres@anarazel.de>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <200809251511.20132.andres@anarazel.de>
References: <200809251511.20132.andres@anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W7pxalu0H10ieI4G40VN"
Date: Fri, 26 Sep 2008 17:10:33 +0200
Message-Id: <1222441833.3798.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W7pxalu0H10ieI4G40VN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 15:11 +0200, Andres Freund wrote:

> I don't know if this is relevant, but I though i better report it.

Thanks. I've also been chasing a DMA corruption issue with iwlagn (on
powerpc).

> This was on fb478da5ba69ecf40729ae8ab37ca406b1e5be48 - sometime after 2.6=
.27-
> rc7
>=20
> I stumbled over two buglets:
> First:
> [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr fa9460=
00=20
> [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not set
> [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting.
> [ 4186.646000] psmouse.c: TouchPad at isa0060/serio1/input0 lost synchron=
ization, throwing 1 bytes away.
> [ 4186.683034] Registered led device: iwl-phy0:radio
> [ 4186.683478] Registered led device: iwl-phy0:assoc
> [ 4186.683793] Registered led device: iwl-phy0:RX
> [ 4186.684094] Registered led device: iwl-phy0:TX
> [ 4186.689749] wlan0: authenticate with AP 00:1d:7e:42:fe:42
> [ 4186.691691] wlan0: authenticated
> [ 4186.691705] wlan0: associate with AP 00:1d:7e:42:fe:42
> [ 4186.696380] wlan0: RX ReassocResp from 00:1d:7e:42:fe:42 (capab=3D0x41=
1 status=3D0 aid=3D2)
> [ 4186.696392] wlan0: associated
>=20
> Most of the time when this happened, the machine wasnt reacting for 1-3=20
> seconds and had audio buffer underruns, but I also had a hard lockup whic=
h I=20
> couldnt diagnose so far.

I suspect the hard lockup was due to a BUG_ON in the iwlagn driver, if
you can reproduce this either try applying the patch here [1] or going
to a VC to see if it crashes there. It's a BUG_ON in iwl-tx.c.

johannes

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/21226


--=-W7pxalu0H10ieI4G40VN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3PtmAAoJEKVg1VMiehFYcHIP/1G/lZaLtpdJteIdRJxLySHx
hW2WjjQKn2XBzMajhDLZaxpyrGt6DVvz3to0MKT9yTQbRW1Vx8FK0yjX2cDkFnRi
17VEp7Xby+g3dvGhGbDdQp6Yn5YfLYJ2JebfKwW9nOc9UDFDLO1qtlEStTg/0S3P
67aqUgl/k7ok4IT7GYFEop8/NjKFjCE6DJyIQmFUHUT027bkIMxMnLaeotUH7zXC
siJk9QBXO9UFfqNzXq8H0Ju7BjVsjvSWnknLJzmZftMclLp+8YXBEHKycjkyF1sg
l/a14LTHw77ZKICAE/M328YW6A/NXmftiBVOCzdw41r5PkDKTOGWThHRCV6JsYtc
aOYoVxWMHn3ReBDzosZ2XQ8vYwQEhSb6qpd6NvNvNxelR9KF+ercjKqGZYzbtxhA
8hukr//X2jZLgb9/i9e+OwjKrAiCvNwP9mxGsFNxR5f/J00pD1mxh2ScINXKX9cR
t8jODXZywoa54k7Bi1em53Kj49D7AM3rzKL+88MfdwkwT3S3M68ZctiV/Qn1Viss
An6KrSSR3wkbeRSEFTC8ygdfJVluQsn8CW1RnzriINydlgZ876inVPNKWVjjghkz
7JJZx9OS8IeuOwn5vPTpmdz0aTNjr4SqmWkHzdSDNthhdFH/OeTkjls5oq21GwRd
x5JQTiVfebJggq4FeUN6
=87/4
-----END PGP SIGNATURE-----

--=-W7pxalu0H10ieI4G40VN--

