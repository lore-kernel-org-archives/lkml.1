Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYFIDCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYFIDCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 23:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbYFIDCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 23:02:40 -0400
Received: from home.keithp.com ([63.227.221.253]:2535 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbYFIDCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 23:02:40 -0400
Subject: Re: [intel-agp] Rewrite GTT on resume
From: Keith Packard <keithp@keithp.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Keith Packard <keith@keithp.com>
In-Reply-To: <20080608071302.GA4739@ucw.cz>
References: <1212550880.4677.5.camel@koto.keithp.com>
	 <20080606135015.3f42820d.akpm@linux-foundation.org>
	 <1212787027.8384.31.camel@koto.keithp.com>  <20080608071302.GA4739@ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mabNoOZqOpFHQDonI1Mq"
Date: Sun, 08 Jun 2008 20:02:15 -0700
Message-Id: <1212980535.10848.19.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mabNoOZqOpFHQDonI1Mq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-08 at 09:13 +0200, Pavel Machek wrote:

> Is this needed in case of iommu enabled, agp disabled, too?

I don't understand this question; if AGP isn't being used, then there
won't be any AGP mappings to rewrite.

> Should this move early (sysdev?) because other drivers may depend on
> iommu working?

I don't need AGP running until userspace is active again; however, that
may change once we move graphics mode setting into the kernel. Dave will
assuredly have a better idea about this than I do.

--=20
keith.packard@intel.com

--=-mabNoOZqOpFHQDonI1Mq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBITJ03Qp8BWwlsTdMRAiVcAJ9H2RFaGfkvsqG+hrqBD7a1LoieWQCg6mSw
+Ky4bLZg6lY3KbHp3T8qj3o=
=jLpA
-----END PGP SIGNATURE-----

--=-mabNoOZqOpFHQDonI1Mq--

