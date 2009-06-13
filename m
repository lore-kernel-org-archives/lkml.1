Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZFML6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZFML6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFML6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:58:36 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49477 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZFML6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:58:35 -0400
Date: Sat, 13 Jun 2009 13:58:30 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 0/7] ASIC3 support for tmio_mmc
Message-ID: <20090613135830.6246d0b8@mjolnir.ossman.eu>
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25488-1244894316-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25488-1244894316-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  4 Jun 2009 20:12:30 +0200
Philipp Zabel <philipp.zabel@gmail.com> wrote:

> I've broken the long lines in patches 1-3 and merged the fix into patch 2:
>  [PATCH 1/7] MFD,mmc: tmio_mmc: make HCLK configurable (v2)
>  [PATCH 2/7] mmc: tmio_mmc: add bus_shift support (v2)
>  [PATCH 3/7] mmc: tmio_mmc: don't use set_irq_type (v2)
>  [PATCH 4/7] mmc: tmio_mmc: correct probe return value for num_resources =
!=3D 3
> Also I've added three new patches for your consideration. Patch 5 delays =
mapping
> of the SD control registers because mfd_cell->enable has to enable the RA=
M first.
> Patch 6 fixes a bug in the SDCLK divider calculation and patch 7 finally =
enables
> compilation of tmio_mmc for ASIC3:
>  [PATCH 5/7] mmc: tmio_mmc: map SD control registers after enabling the M=
FD cell
>  [PATCH 6/7] mmc: tmio_mmc: fix SDCLK divider setting
>  [PATCH 7/7] mmc: tmio_mmc: allow compilation for ASIC3
>=20

I've queued up everything except patch 7 as I haven't seen Ian's
response on that yet.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25488-1244894316-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozlGwACgkQ7b8eESbyJLhOtQCfdsAMAUU3JbySFFc5vmFkpWop
lcAAoMEsB+PONxPJC+GdRT8YQYv8YO66
=lDjw
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25488-1244894316-0001-2--
