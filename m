Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYJDT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYJDT5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYJDT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:57:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:53320 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbYJDT5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:57:23 -0400
Date: Sat, 4 Oct 2008 21:57:14 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081004215714.242f066d@mjolnir.drzeus.cx>
In-Reply-To: <1222851025-30619-1-git-send-email-steven@uplinklabs.net>
References: <20081001083532.GE31009@elte.hu>
	<1222851025-30619-1-git-send-email-steven@uplinklabs.net>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3353-1223150242-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3353-1223150242-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  1 Oct 2008 01:50:25 -0700
Steven Noonan <steven@uplinklabs.net> wrote:

> The variable 'scratch' is always initialized before it's used. The
> conditional which is responsible for initialization of 'scratch' will
> always evaluate 'true' when the first loop iteration occurs, and thus,
> it's properly initialized. GCC doesn't see this, of course, so using
> the uninitialized_var() macro seems to work for silencing this case.
>=20
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

Queued, thanks.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3353-1223150242-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjnyp4ACgkQ7b8eESbyJLjsRgCfQdkQz7cb+47778ZVavHpN3qo
ckIAn0QorOTdGTi9RBlHKKu49Iw3w32R
=m9fa
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3353-1223150242-0001-2--
