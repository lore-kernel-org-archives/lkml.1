Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYFNQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYFNQVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYFNQVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 12:21:04 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41807 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753337AbYFNQVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 12:21:03 -0400
Date: Sat, 14 Jun 2008 18:20:24 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 05/15] MMC: Fix S3C24XX IRQ enable during PIO transfers
 From: Roman Moracik <roman.moravcik@gmail.com>
Message-ID: <20080614182024.03422126@mjolnir.drzeus.cx>
In-Reply-To: <20080606155525.495951151@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
	<20080606155525.495951151@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10591-1213460038-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10591-1213460038-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jun 2008 16:51:22 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Fix Bug #677 - I/O errors on heavy microSD writes for 2.6.22.x.
>=20
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>=20
> Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:01=
.000000000 +0100
> +++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:03.0000=
00000 +0100
> @@ -313,6 +313,7 @@ static void pio_tasklet(unsigned long da
>  {
>  	struct s3cmci_host *host =3D (struct s3cmci_host *) data;
> =20
> +	disable_irq(host->irq);
> =20

This seems harsh. Can't you just fiddle with the interrupt mask of this
specific device?

--=_freyr.drzeus.cx-10591-1213460038-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhT78wACgkQ7b8eESbyJLglnACgsSwGsZPkuJ/7yqPCKEJ1QsD2
WBgAn0w7KEtd7UkXxlG0vz9GgaFwq0Mh
=TC/B
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10591-1213460038-0001-2--
