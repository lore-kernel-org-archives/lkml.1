Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYH3VA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYH3VA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYH3VAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:00:14 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34650 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbYH3VAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:00:12 -0400
Date: Sat, 30 Aug 2008 22:59:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Message-ID: <20080830225950.4828dcf6@mjolnir.drzeus.cx>
In-Reply-To: <20080830174516.GD1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-9247-1220129996-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-9247-1220129996-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Aug 2008 11:45:16 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

>=20
> 2. We should report in GB or TB when appropriate.  The exact definition
> of 'appropriate' is going to vary from person to person.  Might I
> suggest that we should report between two and four significant digits.
> eg 9543 MB is ok, 10543 MB should be 10 GB.
>=20

I've been looking at doing something like this for the mmc_block
driver, so a generic helper is welcome. :)

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-9247-1220129996-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAki5tMkACgkQ7b8eESbyJLi+XwCeMGfeYvIReLdriov3TjmxSBHF
PtUAnA4rOFhL4TXjyKyaYEk86H8vZKXY
=5oE7
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-9247-1220129996-0001-2--
