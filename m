Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYAJTrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYAJTrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYAJTqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:46:52 -0500
Received: from systemlinux.org ([83.151.29.59]:34845 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbYAJTqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:46:50 -0500
Date: Thu, 10 Jan 2008 20:45:50 +0100
From: Andre Noll <maan@systemlinux.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Message-ID: <20080110194550.GB20152@skl-net.de>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <20080110190748.GA20152@skl-net.de> <20080110192950.GG747@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20080110192950.GG747@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:29, Andi Kleen wrote:

> > Sure, I can do that if James likes the idea. Since not all case
> > statements need the BKL, we could add it only to those for which it
> > isn't clear that it is unnecessary.
> >=20
> > And this would actually improve something.
>=20
> I still think it would be a good strategy to first add it to all
> (in a essentially nop semantics patch) and then later eliminate
> it from the cases that obviously don't need it.=20

James, would you accept such a patch?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHhnXuWto1QDEAkw8RAluDAJ4i4avyxYwAI9e/FJSSEvpb+12IOACgpiCz
RQnRIpdQjM4i/8RVo+nVnEA=
=/fp3
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
