Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJ3JKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJ3JKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJ3JKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:10:06 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34167 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbYJ3JKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:10:05 -0400
Date: Thu, 30 Oct 2008 10:09:57 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: mmc: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-ID: <20081030100957.6cba7174@mjolnir.drzeus.cx>
In-Reply-To: <1225331284.5496.12.camel@brick>
References: <1225329600.5970.72.camel@nga.site>
	<1225331284.5496.12.camel@brick>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-9841-1225357802-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-9841-1225357802-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2008 18:48:04 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

>=20
> A lot of these helpers don't seem to add that much, would you care for
> a patch removing them Pierre?
>=20
> Specifically sdio_func_id, sdio_get/set_drvdata don't have that many
> users.
>=20
> mmc_hostname has a lot of users, but if you're agreeable, I could
> take a crack at that too.
>=20

As Marcel said, they provide a nice abstraction (even if it is indeed
a bit silly to have wrappers around wrappers around ..). It also tends
to make the code a bit more readable.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-9841-1225357802-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkJeeoACgkQ7b8eESbyJLgGNQCfY5qXOUxoFV9Qkh3+gAFWIqCH
i50An2K8CSccZvm1d9YDMPi+EMDZbXXn
=LwTp
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-9841-1225357802-0001-2--
