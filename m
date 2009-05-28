Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbZE1Isj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbZE1Isj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZE1Isc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:48:32 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54761 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZE1Isb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:48:31 -0400
Date: Thu, 28 May 2009 10:48:23 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dsaxena@plexity.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-ID: <20090528104823.0a551ecb@mjolnir.ossman.eu>
In-Reply-To: <20090528013629.0173522b.akpm@linux-foundation.org>
References: <20090513200556.GA7882@plexity.net>
	<20090522135150.7e0716d6@mjolnir.ossman.eu>
	<20090528013629.0173522b.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-11135-1243500510-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-11135-1243500510-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2009 01:36:29 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 22 May 2009 13:51:50 +0200 Pierre Ossman <pierre@ossman.eu> wrote:
>=20
> >=20
> > Reading through that report, I don't believe you properly worked around
> > the bug. You only avoid bug 1339, but that's only mildly related.
> >=20
> > What this workaround does is to make sure that MMC_UNSAFE_RESUME
> > actually works. But if you change cards during suspend, the VFS bug
> > should reappear and you'll corrupt the partition table.
>=20
> What do you think the VFS did wrong here?
>=20

Might be the block layer as well. Somehow requests associated with an
old block device end up on the queue of a new block device. I don't
see how this can happen given Linux' device model, but somehow it does.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-11135-1243500510-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoeT9wACgkQ7b8eESbyJLgqHACeNc4Fc4NNV/YIzPV2U/6wsWnf
DTMAoIDv97iFm0s9yli9xHwwQxas54cf
=0Gbh
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-11135-1243500510-0001-2--
