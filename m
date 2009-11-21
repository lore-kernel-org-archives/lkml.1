Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZKUQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZKUQI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZKUQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:08:57 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58014 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZKUQI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:08:57 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 11:08:56 EST
Date: Sat, 21 Nov 2009 17:03:55 +0100
From: Pierre Ossman <pierre-list@ossman.eu>
To: neilb@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Raid not shutting down when disks are lost?
Message-ID: <20091121170355.7540d169@mjolnir.ossman.eu>
In-Reply-To: <20091008163952.679572b5@mjolnir.ossman.eu>
References: <20091008163952.679572b5@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10359-1258819440-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10359-1258819440-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Neil?

On Thu, 8 Oct 2009 16:39:52 +0200
Pierre Ossman <pierre-list@ossman.eu> wrote:

> Today one RAID6 array I manage decided to lose four out of eight disks.
> Oddly enough, the array did not shut down but instead I got
> intermittent read and writer errors from the filesystem.
>=20
> It's been some time since I had a failure of this magnitude, but I seem
> to recall that once the array lost too many disks, it would shut down
> and refuse to write a single byte. The nice effect of this was that if
> it was a temporary error, you could just reboot and the array would
> start nicely (albeit in degraded mode).
>=20
> Has something changed? Is this perhaps an effect of using RAID6 (I used
> to run RAID5 arrays)? Or was I simply lucky the previous instances I've
> had?
>=20
> Related, it would be nice if you could control how it handles lost
> disks. E.g. I'd like it to go read-only when it goes in to fully
> degraded mode. In case the last disk lost was only a temporary glitch,
> the array could be made to recover without a lengthy resync.
>=20
> Rgds


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-10359-1258819440-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksID20ACgkQ7b8eESbyJLiejACg05MdZwtSvLwMK5VXzpjo3HVD
d54AoKypDo1/zObPHGAr/xxdqjuXSQcU
=sDvu
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10359-1258819440-0001-2--
