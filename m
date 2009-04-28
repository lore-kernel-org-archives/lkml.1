Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZD1KgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZD1KgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZD1Kfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:35:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZD1Kft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:35:49 -0400
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <49F6DA14.7030608@tuffmail.co.uk>
References: <49E065CF.6040408@tuffmail.co.uk>
	 <200904140859.02188.bjorn.helgaas@hp.com>
	 <20090414081728.10de978a@infradead.org>
	 <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk>
		 <49EF0ABD.2080801@tuffmail.co.uk> <49F446AE.6070607@tuffmail.co.uk>
		 <49F6CA0E.5040101@tuffmail.co.uk>
	 (sfid-20090428_111942_198975_13CDA6F5) <1240912688.28835.10.camel@johannes.local>
	 <49F6DA14.7030608@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Jprxz+NasVEGsZrS3KWk"
Date: Tue, 28 Apr 2009 12:35:44 +0200
Message-Id: <1240914944.28835.11.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jprxz+NasVEGsZrS3KWk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-28 at 11:27 +0100, Alan Jenkins wrote:

> > Can you point out where? I can't find that.

>=20
> I posted the calltraces earlier at
> <http://marc.info/?l=3Dlinux-wireless&m=3D124074566523506&w=3D2>.
>=20
> wait_for_completion
> flush_cpu_workqueue
> ? wq_barrier_func
> flush_workqueue
> flush_scheduled_work
> tty_ldisc_release

Ah, I was just grepping for the wrong thing :)

johannes

--=-Jprxz+NasVEGsZrS3KWk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9tv9AAoJEKVg1VMiehFY4ugP/1sFv/kru9oViL9kbbpm63mU
cAtEAsnOXGIF+XT9Xp+Jn2z10lUe70aX/xT43eR4jcMw8ER1pKcbx5WymNVp7qvS
4IoBCQEFI0VtH5BrL4yifRtkFF+RLgUdYHsR3cw3aGcE3LDInZDOQgTZlhdiuwaM
rEL0o7xOjn7nEyNKWVZgVIEmOMKf7KdbB+G+T0tlAeeq+MZKowq3Ch38PlitqPO3
3CGW82HlgU2ydGnkcH7Ep48BufJ/tJV/VfaG7ymVGHGcnhl8WOLKRBLT6cJFMwpL
cfUtajLbz9lLfYbqgnWw/wvwrPhmwB1kRq1BXEoF7TaE5TI2Mb4jhC5tY+HWDeap
ICgGQ6Q1d/ttTMbLUliVA5QtbQPVRmyuQD4X+A8IXhkvSeQyN3j+xvMRSVVP0waC
8mkFDeactbPaiCJktuQNjMg0ydxVACmC/4e09G2W+UlEf2lYN3MrQlQME3u0s7xX
E0GGCKyb9i9ale0kzIfLr8FXcV8zbaCcdGtNLODXlc8ZOldC5t/O4wlPTwrv4762
976oU7qIjCU7/X1vNAWlNCxuSg8H6Vbeiprl1cQlRUofXz8eM8cy7ys9ksbFbREf
ez80lBWmdi4F8izE3HZFbLHAJ7xHmHTtk+RwyQFqwpQU62zc+Yn5RvEfBIGkL4e8
VPBwyRnbkgI4LMw8e6Yw
=UJME
-----END PGP SIGNATURE-----

--=-Jprxz+NasVEGsZrS3KWk--

