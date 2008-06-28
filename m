Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYF1OLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYF1OLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYF1OLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:11:33 -0400
Received: from server.drzeus.cx ([85.8.24.28]:48987 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752085AbYF1OLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:11:32 -0400
Date: Sat, 28 Jun 2008 16:11:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080628161127.16b6fcff@mjolnir.drzeus.cx>
In-Reply-To: <20080628160121.10c7c1b0@hskinnemo-gx745.norway.atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
	<20080627211014.0e80db04@siona.local>
	<20080627215627.5d75639c@mjolnir.drzeus.cx>
	<20080628144313.353bbf18@hskinnemo-gx745.norway.atmel.com>
	<20080628154515.0eb002f6@mjolnir.drzeus.cx>
	<20080628160121.10c7c1b0@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8206-1214661683-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8206-1214661683-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2008 16:01:21 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

>=20
> bytes_xfered is 0 if any block failed. If I understand correctly, this
> is good enough, but not optimal. I want to improve this later, but I
> might need some more feedback from the DMA engine subsystem (e.g.
> adding "actual" and "status" fields to the descriptor.)
>=20

That's good enough yes. The only incorrect value is reporting more than
was actually written as that would completely undermine any attempts of
keeping data integrity in upper layers.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8206-1214661683-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhmRpEACgkQ7b8eESbyJLgtMwCgvCZ0qYWkfCHRZ4SH8z3wyGSi
OYUAn2NCYCKGqgZYtBH0cwl+ZbtXXvQB
=KncN
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8206-1214661683-0001-2--
