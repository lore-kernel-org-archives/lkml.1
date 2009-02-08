Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZBHVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZBHVDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZBHVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:03:05 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49047 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbZBHVDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:03:03 -0500
Date: Sun, 8 Feb 2009 22:02:55 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 07/11] sdhci: Add quirk to suppress PIO interrupts
 during DMA transfers
Message-ID: <20090208220255.6fb15ea8@mjolnir.drzeus.cx>
In-Reply-To: <20090206180655.GG11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180655.GG11548@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-4457-1234126980-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-4457-1234126980-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2009 21:06:55 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Some hosts (that is, FSL eSDHC) throw PIO interrupts during DMA
> transfers, this causes tons of unneeded interrupts, and thus highly
> degraded speed.
>=20
> This patch adds SDHCI_QUIRK_PIO_IRQS_DURING_DMA quirk. When specified,
> the sdhci driver will disable PIO interrupts during DMA transfers.
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

It's probably better to change the interrupt handling to only enable
relevant interrupts instead of having everything on constantly. Too
many quirks just makes the driver difficult to understand.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-4457-1234126980-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPSIQACgkQ7b8eESbyJLg1hACbBK5jyGywf72X22+7A2VyU2Z0
e/YAn1Z37Djr5d02dnayfDpn2XUOINGj
=fmlo
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-4457-1234126980-0001-2--
