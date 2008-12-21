Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYLUNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYLUNRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYLUNRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:17:09 -0500
Received: from server.drzeus.cx ([85.8.24.28]:45697 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761AbYLUNRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:17:08 -0500
Date: Sun, 21 Dec 2008 14:16:54 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: smohideen@mx2.labs.rootshell.ws
Cc: Ben Dooks <ben-linux@fluff.org>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] SDHCI: Add timeout hooks
Message-ID: <20081221141654.5468bfe1@mjolnir.drzeus.cx>
In-Reply-To: <20081202164650.GA6414@debian>
References: <20081202154018.906091477@fluff.org.uk>
	<20081202154112.009165156@fluff.org.uk>
	<20081202164650.GA6414@debian>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22439-1229865425-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22439-1229865425-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2008 22:16:50 +0530
smohideen@mx2.labs.rootshell.ws wrote:

>=20
> 	Can we cache the multiple dereferences. Here host->ops can be
> 	saved to a local, instead of multiple dereference several time.
>=20

The ops are used fairly rarely and so far not in any hot-paths, so
there would not be much gain in doing that.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22439-1229865425-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOQdAACgkQ7b8eESbyJLgdWQCgz5FYygSNBe+mpJm33goYvfh1
7O8AoK/UnxSHbyaEmvnZFp+hxGrtvoHG
=VgZr
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22439-1229865425-0001-2--
