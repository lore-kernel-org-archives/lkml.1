Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYFNQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYFNQTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYFNQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 12:19:33 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51087 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752948AbYFNQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 12:19:32 -0400
Date: Sat, 14 Jun 2008 18:18:51 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 01/15] MMC: S3C24XX MMC/SD driver. From: Thomas Kleffel
 <tk@maintech.de>
Message-ID: <20080614181851.01849d03@mjolnir.drzeus.cx>
In-Reply-To: <20080606155524.699256747@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
	<20080606155524.699256747@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10568-1213459946-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10568-1213459946-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jun 2008 16:51:18 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> +#include <linux/mmc/mmc.h>

You don't need this anymore.

> +	//if(cmd->flags & MMC_RSP_MAYFAIL) debug_as_failure =3D 0;

Please remove all the dead code.

> +	if (mrq->data->error =3D=3D MMC_ERR_NONE) {

And rebase against HEAD. MMC_ERR_* are long gone.

Also, please test using the mmc_test driver available in HEAD. A proper
driver should pass all those tests (or possibly mark a few as
unsupported if the hardware is utterly incapable of handling those
requests).

Rgds
Pierre

--=_freyr.drzeus.cx-10568-1213459946-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhT73AACgkQ7b8eESbyJLji8gCcDofge7jDIk7sMm1QoUTgzbtu
Nl4AoOu8i7AbB1Wy2XB4BO5svETZJtOd
=JNBE
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10568-1213459946-0001-2--
