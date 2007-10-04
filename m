Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXJDIqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXJDIqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXJDIqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:46:35 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:58677 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXJDIqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:46:35 -0400
Date: Thu, 4 Oct 2007 10:46:26 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Mullis <dwm@meer.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004104626.2a219926@poseidon.drzeus.cx>
In-Reply-To: <20071004080631.GB23808@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop>
	<20071003231659.f41df5ed.akpm@linux-foundation.org>
	<20071004072515.GC5236@kernel.dk>
	<20071004100154.6093844d@poseidon.drzeus.cx>
	<20071004080631.GB23808@kernel.dk>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-32196-1191487566-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-32196-1191487566-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Oct 2007 10:06:32 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Oct 04 2007, Pierre Ossman wrote:
> >=20
> > Huh? Isn't the block layer supposed to fill in the entire thing?
> > (i.e. current contents shouldn't matter)
>=20
> Yeah, but sg chaining requires that ->page be filled in properly or it
> could confuse it. I think I'll add some debugging to catch that.
>=20

I assume sg_init_one() still can work on an uninitialized sg entry?

Rgds
Pierre


--=_hera.drzeus.cx-32196-1191487566-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBKhj7b8eESbyJLgRAiGMAKCAFybSUVT/WkI0W43ScgDLGAObbgCeN2gO
GTUt2Um6DlR3F6IYehb01Es=
=SPrZ
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-32196-1191487566-0001-2--
