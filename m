Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZCKDKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZCKDKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZCKDKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:10:30 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:53337 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZCKDK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:10:29 -0400
Subject: Re: [PATCH] drm: edid revision 0 is valid
From: Eric Anholt <eric@anholt.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Kyle McMartin <kyle@infradead.org>, airlied@redhat.com,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       jbarnes@virtuousgeek.org, marko.ristola@kolumbus.fi
In-Reply-To: <20090311025636.GA31718@shareable.org>
References: <20090225013153.GC6690@bombadil.infradead.org>
	 <20090311025636.GA31718@shareable.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+NomHNqEqt7d+o6dJfG9"
Date: Tue, 10 Mar 2009 20:10:26 -0700
Message-Id: <1236741026.9354.3.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+NomHNqEqt7d+o6dJfG9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 02:56 +0000, Jamie Lokier wrote:
> Kyle McMartin wrote:
> > -	if (edid->revision <=3D 0 || edid->revision > 3) {
> > +	if (edid->revision > 3) {
> >  		DRM_ERROR("EDID has minor version %d, which is not between 0-3\n", e=
did->revision);
> >  		goto bad;
>=20
> Ahem.  EDID version 1.4 exists too, in fact it's the current version.
> EDID 1.5+ doesn't exist, but it should be backward compatible when it doe=
s.
>=20
> I'm doing a lot of work on another EDID parser, including full DMT and
> CEA-861 mode tables, monitor hotplug, all quirks from Xorg and the
> kernel, EDID 1.4 support w/ CVT calculation, etc. right now for an
> embedded Linux video project.  Would there be any interest
> incorporating parts of that work?

There's work going on for CEA-861 and syncing KMS against UMS.  But
certainly we love fixes when we don't even have to write them ourselves.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-+NomHNqEqt7d+o6dJfG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkm3K6IACgkQHUdvYGzw6vdarQCfe3Be0UIqx3GVmluxLHtylj0G
hxoAmLxJQ7Lz1VQzL8zpYX+zPZL046g=
=Tdv1
-----END PGP SIGNATURE-----

--=-+NomHNqEqt7d+o6dJfG9--

