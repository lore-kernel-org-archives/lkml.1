Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYJNIyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYJNIyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYJNIyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:54:35 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40042 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754154AbYJNIye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:54:34 -0400
Date: Tue, 14 Oct 2008 10:54:25 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: QUEUE_FLAG_NONROT and merges
Message-ID: <20081014105425.4731de06@mjolnir.drzeus.cx>
In-Reply-To: <20081014075407.GU19428@kernel.dk>
References: <20081014095017.265faf37@mjolnir.drzeus.cx>
	<20081014075407.GU19428@kernel.dk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3075-1223974474-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3075-1223974474-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Oct 2008 09:54:08 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Oct 14 2008, Pierre Ossman wrote:
> > Hi Jeff,
> >=20
> > I noticed you've added a new flag to indicate that the drive has no
> > seek costs and I figured it would be a good idea to use that on the
> > MMC/SD cards.
>=20
> That was me, actually...
>=20

Sorry, this was meant for you of course. I don't know how I got things
mixed up there. I guess I'll have to blame lack of coffee this
morning. :)

> > Since the name isn't entirely clear in what is implied, I just wanted
> > to check that there are no plans to assume that there is negligable
> > request overhead for queues with this flag. I.e. the flag should
> > indicate that the elevator doesn't have to care about seeks, but it
> > should still try to merge requests to reduce the transaction overhead.
>=20
> Sounds about right. The flag is just meant to indicate zero-seek cost,
> as devices will still have per-command overheads, merging is still
> applicable.
>=20
> So yes, you want to set that flag for mmc/sd cards, definitely.
>=20

Great. I'll get a patch out ASAP.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3075-1223974474-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEUEARECAAYFAkj0XkYACgkQ7b8eESbyJLjPjQCYrV0dVO8vZraldVkCIXdzGqbB
XwCfWyWa0l+ruKu6B/DNXEIdpECAybU=
=B/qH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3075-1223974474-0001-2--
