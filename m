Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXLIRBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXLIRBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXLIRB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:01:29 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55019 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXLIRB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:01:28 -0500
Date: Sun, 9 Dec 2007 18:01:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: remove unused 'mode' from the mmc_host structure
Message-ID: <20071209180121.22b5948b@poseidon.drzeus.cx>
In-Reply-To: <alpine.LFD.0.99999.0712062257310.555@xanadu.home>
References: <alpine.LFD.0.99999.0712062257310.555@xanadu.home>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-21508-1197219686-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-21508-1197219686-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Dec 2007 23:12:46 -0500 (EST)
Nicolas Pitre <nico@cam.org> wrote:

> This field and corresponding defines are simply never used anywhere
> in the code.  But its mere presence is enough to confuse some host=20
> driver authors who attempt to rely on it.  Let's eliminate the=20
> possibility for confusion and remove it entirely.
>=20
> Signed-off-by: Nicolas Pitre <nico@cam.org>
> ---

Oopsie. Some old stuff since before the restructuring.

>=20
> yes, it's the second host driver I'm reviewing with this issue...
>=20

Seems to be a bit of Windows mentality that spills over. Maybe you should g=
ive them a quick tutorial in that in Linux we fix stuff at the source. ;)

Thanks for the patch. I've queued it up.

Rgds
Pierre

--=_hera.drzeus.cx-21508-1197219686-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHXB9i7b8eESbyJLgRAl8dAKC6ZqEtJVW0j3+bmDAO9g3rsNFUFQCfZx/Q
zN2ADV5VMCGRETUx3moQE9c=
=e0Ta
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-21508-1197219686-0001-2--
