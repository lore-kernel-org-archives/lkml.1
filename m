Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYGDRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYGDRiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYGDRiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:38:13 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40143 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750879AbYGDRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:38:12 -0400
Date: Fri, 4 Jul 2008 19:38:05 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 3/3] mmc: fix sdio_io sparse errors
Message-ID: <20080704193805.54ba8dde@mjolnir.drzeus.cx>
In-Reply-To: <1214812224-32267-3-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
	<1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
	<1214812224-32267-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-446-1215192403-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-446-1215192403-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2008 10:50:24 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> This patch fixes sdio_io sparse errors.
> This fix changes signature of API functions,
> changing
> unsigned char -> u8
> unsigned short -> u16
> unsigned long -> u32 - this was probably a bug in 64 bit platforms
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

I'm not entirely comfortable with this as the point was to use the same
types as the "real" read*/write*. But as i386 and x86_64 use different
types, I don't see much choice.

I've applied the patch.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-446-1215192403-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuYAIACgkQ7b8eESbyJLjKuwCdFv5qxs6fjY1CnAdnLBTuHjk+
6EAAnRhkS3Up4RambH8nxqns4JMPa6+5
=rFV0
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-446-1215192403-0001-2--
