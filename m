Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXCHIw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXCHIw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030302AbXCHIw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:52:28 -0500
Received: from systemlinux.org ([83.151.29.59]:40121 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030288AbXCHIw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:52:27 -0500
Date: Thu, 8 Mar 2007 09:52:09 +0100
From: Andre Noll <maan@systemlinux.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Message-ID: <20070308085209.GB4252@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20070307184641.GY20362@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:46, Jens Axboe wrote:
> On Wed, Feb 28 2007, Andre Noll wrote:
> > On 16:18, Andre Noll wrote:
> >=20
> > > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > > writing to both raid systems at the same time via lvm still locks up
> > > the system within minutes.
> >=20
> > Screenshot of the resulting kernel panic:
> >=20
> > 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
>=20
> Do you have the full oops as well?

Unfortunately not, as there's no way to scroll up after a kernel panic
(the screenshot was taken by using a KVM switch which just sends the
video output over ethernet).

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF7865Wto1QDEAkw8RAqN2AKCQeInbdP1siKAqyT2j0IsBElIFhACdF8IX
82fDYVmZ9K6Q9TgNax3gU1E=
=YsFZ
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
