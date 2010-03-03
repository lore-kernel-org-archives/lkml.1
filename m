Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0CCFeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:34:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0CCFes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:34:48 -0500
Date: Wed, 3 Mar 2010 16:34:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the pcmcia tree
Message-Id: <20100303163443.97767036.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_16_34_43_+1100_H0Zoikr1XXZAu13."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_16_34_43_+1100_H0Zoikr1XXZAu13.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

After merging the pcmcia tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/pcmcia/cistpl.c: In function 'pccard_get_tuple_data':
drivers/pcmcia/cistpl.c:650: warning: comparison of distinct pointer types =
lacks a cast

Introduced by commit d40701ddae35b6594a7366ab5617abe3c24c17e1 ("pcmcia:
CodingStyle fixes").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_16_34_43_+1100_H0Zoikr1XXZAu13.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuN9PMACgkQjjKRsyhoI8zkFgCcDSmGzcbRpe2rQCI1uag1Qn5f
FwIAn1CfCEbuiTwT4VP1MpzvEtOlCY9v
=ciAI
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_16_34_43_+1100_H0Zoikr1XXZAu13.--
