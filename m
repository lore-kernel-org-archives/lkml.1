Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZGPFEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZGPFEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZGPFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:04:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34069 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbZGPFEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:04:14 -0400
Date: Thu, 16 Jul 2009 15:04:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build failure
Message-Id: <20090716150408.e8b4c377.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Jul_2009_15_04_08_+1000_lTsCgic5sAWz/yyV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jul_2009_15_04_08_+1000_lTsCgic5sAWz/yyV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

In file included from drivers/serial/8250.c:37:
include/linux/serial_core.h: In function 'uart_handle_sysrq_char':
include/linux/serial_core.h:445: error: 'struct uart_port' has no member na=
med 'info'

I have used the version of the ttydev tree from next-20090713 (the last
error free one).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Jul_2009_15_04_08_+1000_lTsCgic5sAWz/yyV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpetMgACgkQjjKRsyhoI8zemACgnUs+3TchLwTweYlXdEaFkZ9q
kv8AnROpQUDJLqwsHKhVTZEgXwhLlP+v
=J3bK
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jul_2009_15_04_08_+1000_lTsCgic5sAWz/yyV--
