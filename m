Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYBYRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYBYRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYBYRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:25:18 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37402 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYBYRZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:25:16 -0500
Date: Mon, 25 Feb 2008 18:24:41 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: MMC card detection
Message-ID: <20080225182441.1ed38617@mjolnir.drzeus.cx>
In-Reply-To: <20080221194620.6a3c0030@dhcp-252-066.norway.atmel.com>
References: <20080221194620.6a3c0030@dhcp-252-066.norway.atmel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-17769-1203960315-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-17769-1203960315-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Feb 2008 19:46:20 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

>=20
> When the card is reinserted, the MMC core will try to send a
> SEND_STATUS command again. This time, the card won't respond because it
> is in the "idle" state, and the MMC core will think the card is gone.
>=20
> In order to fix this problem, I think I need a way to tell the MMC core
> that the card really is gone and that there's no point trying to
> communicate with it. Is there any way I can do that?
>=20

As you found out, you can. But the MMC core doesn't treat it
differently.

What is really needed is that the core should make an extra pass and
see if the card has been replaced by something else (and not just check
if it is gone). It's on my todo, but I haven't had time to implement it.

Rgds
Pierre

--=_hera.drzeus.cx-17769-1203960315-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkfC+doACgkQ7b8eESbyJLjbIwCdFhdG5MLz5ub24zjBeeukSCCe
mCUAoOPlGvh0BHiYpkAzqkneIjXoiQ91
=27KR
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-17769-1203960315-0001-2--
