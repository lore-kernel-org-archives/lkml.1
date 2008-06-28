Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYF1Npb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYF1Npb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYF1NpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:45:22 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41033 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752652AbYF1NpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:45:21 -0400
Date: Sat, 28 Jun 2008 15:45:15 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080628154515.0eb002f6@mjolnir.drzeus.cx>
In-Reply-To: <20080628144313.353bbf18@hskinnemo-gx745.norway.atmel.com>
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
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-7521-1214660113-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7521-1214660113-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2008 14:43:13 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Tests 15 and 17 return -EILSEQ instead of -ETIMEDOUT. The at91_mci
> driver has the same problem, and I think it's a hardware issue -- the
> controller wrongly flags a CRC error instead of a data timeout error
> if the card doesn't respond with any CRC status after a write. I don't
> know how to work around that problem.

If that's how the hardware behaves, then EILSEQ will have to do. The
test is more about forcing people to do proper error management in the
driver than anything else. Have a check that you don't report a bad
bytes_xfered though.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7521-1214660113-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhmQG4ACgkQ7b8eESbyJLi5fgCfXI5+I7q29IPBjGghE7XQZNJq
UOMAn3+9O4tmF9xeub4NjNLvFpYPSB1S
=pYO0
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7521-1214660113-0001-2--
