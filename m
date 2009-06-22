Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZFVMxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZFVMxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZFVMxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:53:00 -0400
Received: from systemlinux.org ([83.151.29.59]:47325 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZFVMxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:53:00 -0400
X-Greylist: delayed 1665 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 08:53:00 EDT
Date: Mon, 22 Jun 2009 14:25:07 +0200
From: Andre Noll <maan@systemlinux.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MD: md, fix lock imbalance
Message-ID: <20090622122507.GC11504@skl-net.de>
References: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Efge0/SQAHHP+Pr2"
Content-Disposition: inline
In-Reply-To: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Efge0/SQAHHP+Pr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:59, Jiri Slaby wrote:
> Add unlock and put to one of fail paths in md_alloc.
>=20
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Jup, this patch fixes a leak and a locking bug which hits if a named
array is being added and its name duplicates the name of an already
existing array.

Signed-off-by: Andre Noll <maan@systemlinux.org>
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Efge0/SQAHHP+Pr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKP3gjWto1QDEAkw8RApoLAJ43SghGXTa8tmdbNLWlfVeV/wxNVQCfa0Nl
ZzLDGnhYUKkbFfdhk7vHgwc=
=DNIf
-----END PGP SIGNATURE-----

--Efge0/SQAHHP+Pr2--
