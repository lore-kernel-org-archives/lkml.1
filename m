Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYGJIeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYGJIeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGJId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:33:56 -0400
Received: from server.drzeus.cx ([85.8.24.28]:42261 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbYGJIdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:33:55 -0400
Date: Thu, 10 Jul 2008 10:33:48 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mmc: Export internal host state through debugfs
Message-ID: <20080710103348.53344978@mjolnir.drzeus.cx>
In-Reply-To: <20080705154436.27830440@siona.local>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080704194556.73061a08@mjolnir.drzeus.cx>
	<20080705154436.27830440@siona.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-12366-1215678833-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-12366-1215678833-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Jul 2008 15:44:36 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> On Fri, 4 Jul 2008 19:45:56 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>=20
> > I see that this version has no ifdef:s at all. Doesn't that mean a lot
> > of useless code if DEBUG_FS is not enabled? You embedded guys are
> > usually rather sensitive about such things. :)
>=20
> Hmm...looks like gcc does a pretty poor job of eliminating unreachable
> code, so we end up with about 1k of dead code in debugfs.o.
>=20
> I guess we'll have to throw in a couple of #ifdefs then...
>=20

Have you managed do have a look at this?

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-12366-1215678833-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh1yXAACgkQ7b8eESbyJLhyJQCggYNWJwITQQWPubIojN1MN9fS
+jYAmwbQHm0RutFruNrwgNR0nANx3AN/
=NiV7
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-12366-1215678833-0001-2--
