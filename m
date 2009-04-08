Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbZDHSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbZDHSgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZDHSge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:36:34 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40561 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbZDHSgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:36:33 -0400
Date: Wed, 8 Apr 2009 20:36:26 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Tony Lindgren <tony@atomide.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] omap_hsmmc: Flush posted write to IRQ
Message-ID: <20090408203626.46b03b80@mjolnir.ossman.eu>
In-Reply-To: <20090406164917.GA30724@atomide.com>
References: <49D9EF0F.9090808@nokia.com>
	<20090406164917.GA30724@atomide.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25929-1239215788-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25929-1239215788-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Apr 2009 09:49:18 -0700
Tony Lindgren <tony@atomide.com> wrote:

> * Adrian Hunter <adrian.hunter@nokia.com> [090406 05:00]:
> > From: Kevin Hilman <khilman@deeprootsystems.com>
> >
> > Spurious IRQs seen on MMC after 2.6.29.  Flush posted write in IRQ
> > handler.
> >
> > The interrupt line is released by clearing the error status bits
> > in the MMCHS_STAT register, which must occur before the interrupt
> > handler returns to avoid unwanted irqs.  Hence the need to flush
> > the posted write.
> >
> > Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> > Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
>=20
> Acked-by: Tony Lindgen <tony@atomide.com>
>=20

Queued.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25929-1239215788-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc7qwACgkQ7b8eESbyJLjYuwCg77JcCSPFiQUheTrqTcfz0OFg
Fp8An10zqSIVtTR7DGKqGAswRAxGTGsC
=RIRe
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25929-1239215788-0001-2--
