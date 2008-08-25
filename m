Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYHYUWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYHYUWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYHYUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:22:43 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:27391 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbYHYUWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:22:41 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sally-Anne Edwards <sallyanne.edwards@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1219693601.27921.172.camel@localhost.localdomain>
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
	 <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>
	 <48B3099E.3060407@goop.org>
	 <1219693601.27921.172.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PBj7tLmpmKuAHUblYOii"
Date: Mon, 25 Aug 2008 21:22:33 +0100
Message-Id: <1219695753.27921.175.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Fwd: domU lenny not working: BUG: unable to handle kernel
	paging request at e7437cc0
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PBj7tLmpmKuAHUblYOii
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-25 at 20:46 +0100, Ian Campbell wrote:
>=20
> I thought the tools did this (so expected the Lenny tools to be
> correct) but looking at the code it seems it is the domain 0 kernel
> which does it.

Uh, I'm thinking backwards here. It's the frontend which writes it but
the backend needs to understand it which the Etch kernel does not.

Unfortunately this means that writing the protocol node as I suggest
won't work.

Only thing I can recommend at the moment is to use a kernel which does
have this (i.e. one from
http://xenbits.xensource.com/linux-2.6.18-xen.hg) or to use a 32 bit
Etch kernel if you want to run 32 bit guests.

Ian.
--=20
Ian Campbell

If life isn't what you wanted, have you asked for anything else?

--=-PBj7tLmpmKuAHUblYOii
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkizFIgACgkQM0+0qS9rzVld9QCgz/5t+cHHoJfF0Rel7H3RYoIf
IU4An0n5vDWQ5POZN4x9gKLpfGZlKp2M
=08mr
-----END PGP SIGNATURE-----

--=-PBj7tLmpmKuAHUblYOii--

