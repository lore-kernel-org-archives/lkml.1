Return-Path: <linux-kernel-owner+w=401wt.eu-S939965AbYCSWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939965AbYCSWLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbYCSUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:38:06 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35681 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029AbYCSUiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:38:02 -0400
Date: Tue, 18 Mar 2008 19:20:18 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, benzizbit@gmail.com
Subject: Re: SDIO: IO-Ready Bit
Message-ID: <20080318192018.1815fd57@mjolnir.drzeus.cx>
In-Reply-To: <1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
	<20080318123325.0843b854@mjolnir.drzeus.cx>
	<1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-6176-1205864472-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-6176-1205864472-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Mar 2008 19:43:40 +0200
"Tomas Winkler" <tomasw@gmail.com> wrote:

> On Tue, Mar 18, 2008 at 1:33 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> >
> >  A better approach is to simply have the drivers for your subfunctions =
synchronize things. Make sure noone calls sdio_enable_func() until the firm=
ware has been loaded.
>=20
> This could even be done from user space in case you want to use a
> standard driver.
>=20
> Won't this prevent us from compiling the drivers into kernel?
> Second how this possible especially with standard driver as they are
> loaded. I know you can enforce module loading but how can you enforce
> probing order form user space?

You can tell the kernel to not automatically attach drivers to devices.
That way you can have a user space process control exactly the order
and timing of things. I haven't played around with this feature myself
though, so I can't really provide you with any good information on how
to use it. You should be able to google up something useful.

Rgds
Pierre

--=_hera.drzeus.cx-6176-1205864472-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iEYEARECAAYFAkfgB+gACgkQ7b8eESbyJLhWCgCeJJJoU/ZMMkjYSQjmnJ4Wcogi
bTkAoMNjHV1QRhJ/PPXDv16Kzme4qdQh
=sAgd
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-6176-1205864472-0001-2--
