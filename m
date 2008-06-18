Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYFRLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYFRLQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYFRLQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:16:29 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3578 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYFRLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:16:29 -0400
Date: Wed, 18 Jun 2008 13:16:07 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Pierre Ossman <drzeus@drzeus.cx>,
       Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       hjk@linutronix.de, Russell King <rmk@arm.linux.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Message-ID: <20080618111607.GB6788@gateway.home>
References: <483FE9E7.7020707@atmel.com> <20080609124623.5b6bda48@mjolnir.drzeus.cx> <484E4F61.7010007@atmel.com> <20080614182831.0360bd77@mjolnir.drzeus.cx> <4858DDC1.6080802@atmel.com> <20080618104723.GA6788@gateway.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20080618104723.GA6788@gateway.home>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 12:47:23PM +0200, Erik Mouw wrote:
> On Wed, Jun 18, 2008 at 12:04:49PM +0200, Nicolas Ferre wrote:
>=20
> [...]
>=20
> Could you all drop =3D?ISO-8859-1?Q?Hans-J=3DFCrgen_?=3D from the Cc list=
 in
> this thread? The address is invalid because it has no domain part and
> hence causes quite some bounces on the list because some strict email
> checkers reject invalid addresses in the Cc list.
>=20
> I'm trying to figure out what went wrong, but in the mean time please
> drop =3D?ISO-8859-1?Q?Hans-J=3DFCrgen_?=3D from the Cc list.

Found it, Mailman is to blame. On the linux-kernel mailing list, the
address shows up ok: "=3D?ISO-8859-1?Q?Hans-J=3DFCrgen_?=3D
=3D?ISO-8859-1?Q?Koch?=3D <hjk@linutronix.de>".

What probably happens: Mailman tries to check if the addresses in the
To and CC fields are subscribed to the list (linux-arm-kernel). If that
is the case and the subscriber enabled "prevent doubles", it won't send
that particular subscriber the message. Of course, this should have
been implemented by a simple strncmp() on the To and CC fields, but I
guess Mailman first breaks up the To and CC fields, then does the
"prevent double" check, and then reassembles the To and CC fields.
Apparently there is an error in the break up or reassembly. Now how to
fix this without breaking Mailman alltogether...

In the mean time, could you just use Hans-J=FCrgen's address
(hjk@linutronix.de>) and not his name in the CC field?


Erik
[linux-arm-kernel-owner #2]
(thanks to David Woodhouse for helping to debug the problem)

--=20
Erik Mouw -- mouw@nl.linux.org

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFIWO53/PlVHJtIto0RAhGjAJjfQG+QU/8f6ImLrBtQpDDYCEL9AJ0T1lI3
4HyPkvcEUYbxBxQpGEGZhw==
=8rgF
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
