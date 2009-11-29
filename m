Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZK2XBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZK2XBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZK2XBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:01:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54373 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZK2XBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:01:51 -0500
Date: Mon, 30 Nov 2009 10:01:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <len.brown@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: linux-next: origin tree build warning
Message-Id: <20091130100149.a951b65a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_10_01_49_+1100_W98rTpAbOOgREX9."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Nov_2009_10_01_49_+1100_W98rTpAbOOgREX9.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/platform/x86/thinkpad_acpi.c:2224: warning: 'tpacpi_hotkey_driver_m=
ask_set' defined but not used

Introduced by commit 8b468c0c85f41c4c55227c17271b4187d8911fb0
("thinkpad-acpi: add internal hotkey event API").  This entered Linus'
tree before 2.6.32-rc1.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_10_01_49_+1100_W98rTpAbOOgREX9.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksS/V0ACgkQjjKRsyhoI8xxxACcCkchJXo9OHuQG3fDrkP0t8sY
a+EAniT0YI1AGm1RXSnp4tjR2p0dHmHR
=fXer
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_10_01_49_+1100_W98rTpAbOOgREX9.--
