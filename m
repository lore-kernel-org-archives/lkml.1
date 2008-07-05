Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYGEX0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYGEX0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYGEX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:26:39 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50763 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbYGEX0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:26:38 -0400
Date: Sun, 6 Jul 2008 01:26:31 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/2 V2] MMC: cleanup endianity conversions and style
 problems
Message-ID: <20080706012631.5e43624c@mjolnir.drzeus.cx>
In-Reply-To: <1215276725-15588-2-git-send-email-tomas.winkler@intel.com>
References: <1215276725-15588-1-git-send-email-tomas.winkler@intel.com>
	<1215276725-15588-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-16121-1215300396-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-16121-1215300396-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  5 Jul 2008 19:52:05 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> This patch cleans up endianity conversions im mmc core
> and style errors in the 'for' statements
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

NAK in its current form. The data needs to be DMA:able, which means
that the stack cannot be used.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-16121-1215300396-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhwAywACgkQ7b8eESbyJLhu9wCgxv/nb3RrUapd4Zny9DT82TUK
lOkAoJGQrV1tRwJP3xzI3+WbbmrWdzuz
=//Wc
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-16121-1215300396-0001-2--
