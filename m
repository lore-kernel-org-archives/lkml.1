Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbZABW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbZABW4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbZABW4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:56:07 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:55008 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZABW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:56:05 -0500
Subject: Re: worth submitting a detailed EDID structure?
From: Eric Anholt <eric@anholt.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901020906310.12465@localhost.localdomain>
References: <alpine.LFD.2.00.0901020906310.12465@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tFnbVdkV/3xs7zkHqxtT"
Date: Fri, 02 Jan 2009 14:55:56 -0800
Message-Id: <1230936956.6095.5.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tFnbVdkV/3xs7zkHqxtT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-02 at 09:08 -0500, Robert P. J. Day wrote:
> just noticed the header file include/video/edid.h, which defines
> video EDID info as simply:
>=20
>   struct edid_info {
>         unsigned char dummy[128];
>   };
>=20
> a couple months back, i had to mess with EDID info and defined a
> detailed structure to manipulate EDID fields.  is it worth submitting
> that as a patch and union'ing that with the above?  not a big deal for
> me either way.

The KMS code already has detailed EDID structures in drm_edid.h, for
what it's worth.  We still need to get CEA extension bits ported over,
though.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-tFnbVdkV/3xs7zkHqxtT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklem3wACgkQHUdvYGzw6veVAgCglz1Go+w7TfQVn8D99cmFJrVA
+ggAniMUPSOmcmnQobzweFItz4xvn7cd
=j8Sl
-----END PGP SIGNATURE-----

--=-tFnbVdkV/3xs7zkHqxtT--

