Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYHNMjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYHNMjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYHNMjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:39:44 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52938 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478AbYHNMjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:39:44 -0400
Date: Thu, 14 Aug 2008 14:39:35 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: can block drivers get non-fs requests?
Message-ID: <20080814143935.7033631e@mjolnir.drzeus.cx>
In-Reply-To: <20080814114209.GB20055@kernel.dk>
References: <20080814133810.746751cf@mjolnir.drzeus.cx>
	<20080814114209.GB20055@kernel.dk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24950-1218717582-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24950-1218717582-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2008 13:42:09 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> You should check in the driver whether the request type is supported. So
> if you can only handle fs requests, you should do a check for
> !blk_fs_request() after elv_next_request() and call
> end_(de)queued_request() appropriately.
>=20

So killing off the request with -EOPNOTSUPP is preferred over having a
prepare function and stopping it there?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24950-1218717582-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkikJ4wACgkQ7b8eESbyJLgILACdG7TKmip+do3TKfQkJULydUYk
7DUAnjOhcLXaWJ0CpweB5WO6V78N30NB
=EKTL
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24950-1218717582-0001-2--
