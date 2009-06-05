Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZFEBhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZFEBhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZFEBhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:37:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39158 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZFEBhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:37:10 -0400
Date: Fri, 5 Jun 2009 11:37:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: linux-next: mmc tree build warning
Message-Id: <20090605113707.0f87467f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Jun_2009_11_37_07_+1000_v8EHFvHXLFMcbyLf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Jun_2009_11_37_07_+1000_v8EHFvHXLFMcbyLf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

Today's linux-next build (x86_64 allmodconfig) produced this warnings:

drivers/misc/cb710/debug.c: In function 'cb710_read_regs_8':
drivers/misc/cb710/debug.c:100: warning: suggest parentheses around operand=
 of '!' or change '&' to '&&' or '!' to '~'
drivers/misc/cb710/debug.c: In function 'cb710_read_regs_16':
drivers/misc/cb710/debug.c:101: warning: suggest parentheses around operand=
 of '!' or change '&' to '&&' or '!' to '~'
drivers/misc/cb710/debug.c: In function 'cb710_read_regs_32':
drivers/misc/cb710/debug.c:102: warning: suggest parentheses around operand=
 of '!' or change '&' to '&&' or '!' to '~'
In file included from drivers/mmc/host/cb710-mmc.h:13,
                 from drivers/mmc/host/cb710-mmc.c:15:
include/linux/cb710.h:14:1: warning: "DEBUG" redefined
<command-line>: warning: this is the location of the previous definition
drivers/mmc/host/cb710-mmc.c: In function 'cb710_mmc_set_transfer_size':
drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', =
but argument 4 has type 'size_t'
drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', =
but argument 6 has type 'size_t'

All introduced by commit ecb9ca267b42dc8c9a35eeaf75c002159fa52602 ("mmc:
Driver for CB710/720 memory card reader (MMC part)").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Jun_2009_11_37_07_+1000_v8EHFvHXLFMcbyLf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoodsMACgkQjjKRsyhoI8ySOACdG6IZbBCnzu9zxq3O4iQdiM7l
TXUAoKJKdANxXAmpDnFMS2cseAP9iUPI
=oJj3
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Jun_2009_11_37_07_+1000_v8EHFvHXLFMcbyLf--
