Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYBGIJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYBGIJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYBGIJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:09:24 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38131 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYBGIJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:09:23 -0500
Date: Thu, 7 Feb 2008 09:08:34 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Frank Seidel <fseidel@suse.de>
Cc: Philip Langdale <philipl@overt.org>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [PATCH v2] mmc: extend ricoh_mmc to support Ricoh RL5c476
Message-ID: <20080207090834.3c6fde7d@poseidon.drzeus.cx>
In-Reply-To: <200802041925.43081.fseidel@suse.de>
References: <200801311838.24743.fseidel@suse.de>
	<47A418E0.6040205@overt.org>
	<200802041925.43081.fseidel@suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-10888-1202371761-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-10888-1202371761-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Feb 2008 19:25:42 +0100
Frank Seidel <fseidel@suse.de> wrote:

> From: Frank Seidel <fseidel@suse.de>
>=20
> This patch (base on current linus git tree plus Philip Langdales
> suspend/resume patch) adds support for the Ricoh RL5c476 chip:
> with this the mmc adapter that needs this disabler (R5C843) can
> also be handled correctly when it sits on a RL5c476.
> (+ minor style changes (removed spaces between function names
> and open parenthesis .. checkpatch warned from previos patch))
>=20
> Signed-off-by: Frank Seidel <fseidel@suse.de>

I see you've guys have kept yourself busy in my absence. :)

As for the patch, it looks ok although I'm not really a fan of more voodoo =
constants that noone knows what they mean. Could you add some comments expl=
aining some of them at least?

> +	if (fw_dev->device =3D=3D PCI_DEVICE_ID_RICOH_RL5C476) {

*snip*

> +	} else {
> +		/* via R5C832 */

Wouldn't it be prudent to have a check that this is indeed a R5C832, and a =
failure mode if it's none of the two known devices?

Rgds
Pierre

--=_hera.drzeus.cx-10888-1202371761-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeqvIIACgkQ7b8eESbyJLg79ACgiycCLbDv7QnI4TrpzMQwC7hj
7/EAn3+wNDG1loJDCCb/mf7Lkexz6AoX
=YWjA
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-10888-1202371761-0001-2--
