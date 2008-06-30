Return-Path: <linux-kernel-owner+w=401wt.eu-S1763018AbYF3SDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018AbYF3SDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYF3SDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:03:31 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41216 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753300AbYF3SDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:03:31 -0400
Date: Mon, 30 Jun 2008 20:03:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: How to alloc highmem page below 4GB on i386?
Message-ID: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10147-1214848374-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10147-1214848374-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Simple question. How do I allocate a page from highmem, that's still
within 32 bits? x86_64 has the DMA32 zone, but i386 has just HIGHMEM.
As most devices can't DMA above 32 bit, I have 3 GB of memory that's
not getting decent usage (or results in needless bouncing). What to do?

I tried just enabling CONFIG_DMA32 for i386, but there is some guard
against too many memory zones. I'm assuming this is there for a good
reason?

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-10147-1214848374-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhpH/EACgkQ7b8eESbyJLj7XQCgl6dThmKpkBEYOHfHkQfZmL1R
NGUAn2yb6QHeq9lLk/w+HJUIIM5afRJ/
=cOPe
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10147-1214848374-0001-2--
