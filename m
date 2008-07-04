Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYGDR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYGDR6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYGDR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:58:11 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39303 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbYGDR6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:58:10 -0400
Date: Fri, 4 Jul 2008 19:58:00 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: How to alloc highmem page below 4GB on i386?
Message-ID: <20080704195800.4ef6e00a@mjolnir.drzeus.cx>
In-Reply-To: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
References: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-876-1215193601-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-876-1215193601-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2008 20:03:23 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Simple question. How do I allocate a page from highmem, that's still
> within 32 bits? x86_64 has the DMA32 zone, but i386 has just HIGHMEM.
> As most devices can't DMA above 32 bit, I have 3 GB of memory that's
> not getting decent usage (or results in needless bouncing). What to do?
>=20
> I tried just enabling CONFIG_DMA32 for i386, but there is some guard
> against too many memory zones. I'm assuming this is there for a good
> reason?
>=20

Anyone?

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-876-1215193601-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuZLAACgkQ7b8eESbyJLi5dgCeIw6rCoDUDfvdqEZ6lwQFtT70
hpoAn3RAVQ0OFZMSSF3OnMYq4U/aHtI0
=NFbH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-876-1215193601-0001-2--
