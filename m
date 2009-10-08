Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZJHOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZJHOkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbZJHOku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:40:50 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45132 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbZJHOkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:40:41 -0400
Date: Thu, 8 Oct 2009 16:39:52 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>
Subject: Raid not shutting down when disks are lost?
Message-ID: <20091008163952.679572b5@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-19831-1255012805-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-19831-1255012805-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Today one RAID6 array I manage decided to lose four out of eight disks.
Oddly enough, the array did not shut down but instead I got
intermittent read and writer errors from the filesystem.

It's been some time since I had a failure of this magnitude, but I seem
to recall that once the array lost too many disks, it would shut down
and refuse to write a single byte. The nice effect of this was that if
it was a temporary error, you could just reboot and the array would
start nicely (albeit in degraded mode).

Has something changed? Is this perhaps an effect of using RAID6 (I used
to run RAID5 arrays)? Or was I simply lucky the previous instances I've
had?

Related, it would be nice if you could control how it handles lost
disks. E.g. I'd like it to go read-only when it goes in to fully
degraded mode. In case the last disk lost was only a temporary glitch,
the array could be made to recover without a lengthy resync.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-19831-1255012805-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkrN+cEACgkQ7b8eESbyJLj+BwCgiM5J62B3tGzVDPBXSif1Yoni
HfIAoJHH3s96/hKsnSXODxAqwxR6kbco
=NCMf
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-19831-1255012805-0001-2--
