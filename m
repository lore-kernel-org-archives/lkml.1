Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZKYUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZKYUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbZKYUfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:35:45 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:42979 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbZKYUfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:35:44 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 15:35:44 EST
Date: Wed, 25 Nov 2009 21:30:36 +0100
From: Pierre Ossman <pierre@ossman.eu>
To: Philip Langdale <philipl@overt.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Port ricoh_mmc from driver to pci quirk.
Message-ID: <20091125213036.7afa636b@mjolnir.ossman.eu>
In-Reply-To: <20091125085324.1ef9ae1f@fido2.homeip.net>
References: <1259021583.16650.9.camel@maxim-laptop>
	<20091123162119.3777e14d@fido2.homeip.net>
	<1259160947.10147.1.camel@maxim-laptop>
	<1259161121.10147.4.camel@maxim-laptop>
	<20091125085324.1ef9ae1f@fido2.homeip.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-1973-1259181042-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-1973-1259181042-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Nov 2009 08:53:24 -0800
Philip Langdale <philipl@overt.org> wrote:

> On Wed, 25 Nov 2009 16:58:41 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>=20
> > >From 5c5e6f5ab1a5a09a430f410cab4b160a5e65501c Mon Sep 17 00:00:00
> > >2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Wed, 25 Nov 2009 16:37:46 +0200
> > Subject: [PATCH] Port ricoh_mmc from driver to pci quirk.
> >  This is much cleaner and correct solution
>=20
> I'm fine with the concept, but when I originally started work on
> Ricoh support, Pierre specifically didn't want a pci quirk.
>=20
> Pierre wrote:
> > I'd rather we didn't. The current style of quirks are bad enough,
> > making them even more vendor or device specific is a bit more than I'm
> > willing to accept right now (seriously, how hard can it be to follow
> > the damn spec?).
>=20
> Pierre's not officially the maintainer anymore but I still respect his
> opinions here. Given that a pci quirk solves this problem so simply,
> I think it's justified at this point.
>=20
> Pierre, do you want to comment?
>=20

I was talking about the quirks mechanism in sdhci, not pci quirks. :)

I have no objections to this patch.

>=20
> I would at least suggest a printk so ensure people know this is
> happening - otherwise there's no visible evidence that the system
> even has an MMC controller that's been disabled.
>=20

Agreed. There might be cases where we cause problems since we don't
fully understand this hardware.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-1973-1259181042-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksNk+8ACgkQ7b8eESbyJLhMKACdF9GK8CgjFJiVGVZ79+JkW1C0
F+4An2wT0jvfPx6C+0ldW3NUAjfb8j9w
=JJN/
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-1973-1259181042-0001-2--
