Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZBSLAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZBSLAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZBSLAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:00:37 -0500
Received: from mail.technotrend.de ([212.185.20.147]:52815 "EHLO
	mail.technotrend.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZBSLAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:00:37 -0500
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 06:00:37 EST
Date: Thu, 19 Feb 2009 11:50:13 +0100
From: Martin Zwickel <martin.zwickel@technotrend.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [saa7146] v4l 32bit ioctl compat patch
Message-ID: <20090219115013.75449e6b@dieter.augsburg>
X-Mailer: Claws Mail 3.7.0cvs56 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
X-Operating-System: Linux Dieter 2.6.25.1 x86_64  Intel(R) Core(TM)2 Quad
 CPU Q6600 @ 2.40GHz
Organization: Technotrend AG
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l1y+Qarr4GK+TMixKm77F+j";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/l1y+Qarr4GK+TMixKm77F+j
Content-Type: multipart/mixed; boundary="MP_/zP13K/sF+l/gwSjLMxMXzMe"

--MP_/zP13K/sF+l/gwSjLMxMXzMe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

what do you think about such a patch to get 32bit ioctl compat working for
saa7146 driver?

Thanks and regards,
Martin

--=20
MyExcuse:
static from nylon underwear

Martin Zwickel <martin.zwickel@technotrend.de>
Research & Development

--MP_/zP13K/sF+l/gwSjLMxMXzMe
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dvb_ttpci_v4l_compat_ioctl32.patch

diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff -x probe.c -x v=
dso.lds linux-2.6.23.1-vanilla/drivers/media/common/saa7146_fops.c linux-2.=
6.23.1/drivers/media/common/saa7146_fops.c
--- linux-2.6.23.1-vanilla/drivers/media/common/saa7146_fops.c	2007-10-12 1=
8:43:44.000000000 +0200
+++ linux-2.6.23.1/drivers/media/common/saa7146_fops.c	2007-11-27 14:03:57.=
000000000 +0100
@@ -425,6 +425,7 @@ static const struct file_operations vide
 	.poll		=3D fops_poll,
 	.mmap		=3D fops_mmap,
 	.ioctl		=3D fops_ioctl,
+	.compat_ioctl	=3D v4l_compat_ioctl32,
 	.llseek		=3D no_llseek,
 };
=20

--MP_/zP13K/sF+l/gwSjLMxMXzMe--

--Sig_/l1y+Qarr4GK+TMixKm77F+j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmdOWsACgkQmjLYGS7fcG292QCghpWOBNWRtHz2oMDoM2SLEIUA
CVUAnjdWyqgdq0ThJmRx7RdOvGX9dFC+
=C8xs
-----END PGP SIGNATURE-----

--Sig_/l1y+Qarr4GK+TMixKm77F+j--
