Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZBHUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZBHUxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBHUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:53:21 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60409 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZBHUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:53:21 -0500
Date: Sun, 8 Feb 2009 21:53:10 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 03/11] sdhci: Add type checking for IO memory accessors
Message-ID: <20090208215310.22a8239b@mjolnir.drzeus.cx>
In-Reply-To: <20090206180648.GC11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180648.GC11548@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3867-1234126398-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3867-1234126398-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2009 21:06:48 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> A new restricted integer type introduced: sdhci_reg_t.
>=20
> Header file now specifies registers via sdhci_reg() inline function.
> Only one place (not counting sdhci_def_*() accessors) need to cast
> a register back to an offset, i.e. sdhci_finish_command().
>=20
> From now on sparse tool will warn about IO memory accessors misuses,
> for exampple:
>=20
> sdhci_writeb(host, SDHCI_TIMEOUT_CONTROL, count);
>=20
>   CHECK   sdhci.c
> sdhci.c:614:21: warning: incorrect type in argument 2 (different base typ=
es)
> sdhci.c:614:21:    expected unsigned char [unsigned] [usertype] val
> sdhci.c:614:21:    got restricted int
> sdhci.c:614:44: warning: incorrect type in argument 3 (different base typ=
es)
> sdhci.c:614:44:    expected restricted int [usertype] reg
> sdhci.c:614:44:    got unsigned char [unsigned] [assigned] [usertype] cou=
nt
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

Is this really a problem? It's a lot of noise in the code and I can't
really see this as a major issue, or even a minor one. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3867-1234126398-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPRj0ACgkQ7b8eESbyJLjThACg291FPLnUFcUeDma3Ewc/PcTb
5+EAn2C4Tb5nNZM40WXG6yV7jJN9sSUO
=dcFE
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3867-1234126398-0001-2--
