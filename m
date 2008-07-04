Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYGDRNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYGDRNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYGDRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:13:28 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39157 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbYGDRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:13:27 -0400
Date: Fri, 4 Jul 2008 19:13:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, Benzi Zbit <Benzi.Zbit@intel.com>
Subject: Re: [PATCH 1/3] mmc_core: fix the use of hard coded timeout value.
Message-ID: <20080704191320.245fa2e6@mjolnir.drzeus.cx>
In-Reply-To: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-367-1215190918-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-367-1215190918-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2008 10:50:22 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> From: Benzi Zbit <Benzi.Zbit@intel.com>
>=20
> Signed-off-by: Benzi Zbit <Benzi.Zbit@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

A nice addition, but I'm afraid that field is not present on all cards
(it was added in version 1.1). Could you make sure you have the proper
guards and a fallback?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-367-1215190918-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuWjUACgkQ7b8eESbyJLh9KACgjFtsirL9L1mFqbAbVWLgB3nU
pXwAoK2DQ923/jNjUjq2j3tOsKpWjkkX
=3JiA
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-367-1215190918-0001-2--
