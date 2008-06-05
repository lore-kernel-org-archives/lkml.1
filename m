Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbYFEVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbYFEVDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFEVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:03:44 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50718 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbYFEVDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:03:42 -0400
Date: Thu, 5 Jun 2008 23:03:11 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Manuel Lauss <mano@roarinelk.homelinux.net>, ralf@linux-mips.org
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
Message-ID: <20080605230311.7f98cd1a@mjolnir.drzeus.cx>
In-Reply-To: <20080519094953.GA22445@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net>
	<20080519080416.GB21985@roarinelk.homelinux.net>
	<483149E0.6010009@ru.mvista.com>
	<20080519094953.GA22445@roarinelk.homelinux.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.1; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26245-1212699512-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26245-1212699512-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2008 11:49:53 +0200
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> Hi Sergei,
>=20
> >> From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
> >> From: Manuel Lauss <mlau@msc-ge.com>
> >> Date: Wed, 7 May 2008 13:42:55 +0200
> >> Subject: [PATCH] Alchemy: export get_au1x00_speed for modules
> >>
> >> au1xmmc.c driver depends on it, so export it for modules.
> >>
> >> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> >>  =20
> >
> >   I thought that has been merged.
>=20
> Yes, Ralf merged it into linux-mips repo, but it is not yet in
> mainline and the rest of the patches are against linus' git.
>=20

So who should push this to Linus? If this set is the only patches
depending on it, it would be easiest if I carry it in my tree.

Rgds
Pierre

--=_freyr.drzeus.cx-26245-1212699512-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhIVJQACgkQ7b8eESbyJLheAwCdEbCUdthYIFY9xWyPlgzf8j5s
NB4AoN7J9S8IZiCVuPjHMjETlskzPz2P
=vy/z
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26245-1212699512-0001-2--
