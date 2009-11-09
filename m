Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZKIHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZKIHkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZKIHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:40:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZKIHko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:40:44 -0500
Date: Mon, 9 Nov 2009 18:40:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rr tree build warnings
Message-Id: <20091109184046.2a802372.sfr@canb.auug.org.au>
In-Reply-To: <20091109183104.2bf7add6.sfr@canb.auug.org.au>
References: <20091109183104.2bf7add6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_18_40_46_+1100_BTVQl9ptSjXaTqLq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_18_40_46_+1100_BTVQl9ptSjXaTqLq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 9 Nov 2009 18:31:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
>=20
> drivers/usb/storage/libusual.c:239: warning: passing argument 1 of '__che=
ck_old_set_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/usb/storage/libusual.c:239: warning: passing argument 1 of '__che=
ck_old_set_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/usb/storage/libusual.c:239: warning: passing argument 1 of '__che=
ck_old_set_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/usb/storage/libusual.c:239: warning: passing argument 1 of '__che=
ck_old_set_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
>=20
> Introduced by commit 9f94999724555729819ea0143eab1d0529c029d1
> ("param:param_ops").

I am also getting some section mismatch warnings like this:

WARNING: drivers/mtd/ubi/ubi.o(.data+0x1c0): Section mismatch in reference =
from the variable __ops_mtd to the function .init.text:ubi_mtd_param_parse()
The variable __ops_mtd references
the function __init ubi_mtd_param_parse()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console=
,=20

Which are probably also related to the above change.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_18_40_46_+1100_BTVQl9ptSjXaTqLq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3x34ACgkQjjKRsyhoI8yWngCfQtKEgW1tSmzJaO/nX9AwP3XT
5hkAnj7PNoHvoL7ZHn+hF92wzJriLsDI
=UywA
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_18_40_46_+1100_BTVQl9ptSjXaTqLq--
