Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbYJNHus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbYJNHus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYJNHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:50:39 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52620 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753076AbYJNHuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:50:39 -0400
Date: Tue, 14 Oct 2008 09:50:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: QUEUE_FLAG_NONROT and merges
Message-ID: <20081014095017.265faf37@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2624-1223970637-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2624-1223970637-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

I noticed you've added a new flag to indicate that the drive has no
seek costs and I figured it would be a good idea to use that on the
MMC/SD cards.

Since the name isn't entirely clear in what is implied, I just wanted
to check that there are no plans to assume that there is negligable
request overhead for queues with this flag. I.e. the flag should
indicate that the elevator doesn't have to care about seeks, but it
should still try to merge requests to reduce the transaction overhead.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2624-1223970637-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkj0Tz4ACgkQ7b8eESbyJLhhCACg1nI3svz6sfcNMZ3KZi2uxO33
dHIAoLqtUqfJ/pnFnTNQJ24uZi0nJj9O
=NThN
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2624-1223970637-0001-2--
