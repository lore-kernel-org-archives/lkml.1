Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYH3WNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYH3WNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYH3WNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:13:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:54169 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754926AbYH3WNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:13:22 -0400
Date: Sun, 31 Aug 2008 00:13:14 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Message-ID: <20080831001314.694df795@mjolnir.drzeus.cx>
In-Reply-To: <1220132749.3615.14.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
	<20080830225950.4828dcf6@mjolnir.drzeus.cx>
	<1220132749.3615.14.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-9724-1220134401-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-9724-1220134401-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Aug 2008 16:45:49 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-08-30 at 22:59 +0200, Pierre Ossman wrote:
> > On Sat, 30 Aug 2008 11:45:16 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> >=20
> > >=20
> > > 2. We should report in GB or TB when appropriate.  The exact definiti=
on
> > > of 'appropriate' is going to vary from person to person.  Might I
> > > suggest that we should report between two and four significant digits.
> > > eg 9543 MB is ok, 10543 MB should be 10 GB.
> > >=20
> >=20
> > I've been looking at doing something like this for the mmc_block
> > driver, so a generic helper is welcome. :)
>=20
> Does MMC have the 10^3 requirement like SCSI/ATA disks do, or can you
> use 2^10 like standard computer stuff for capacities?
>=20

Some do, some don't. I prefer the 2^10 and MiB variants as it avoids
ambiguity.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-9724-1220134401-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAki5xf0ACgkQ7b8eESbyJLicpwCfRKFa+znA6lvAZ4d7rfm31lCr
DR4AnifUFHYhWX+lGO1WuRiO6m8VTuzn
=xLaW
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-9724-1220134401-0001-2--
