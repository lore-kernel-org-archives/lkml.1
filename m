Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYBKRG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYBKRG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbYBKRGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:06:18 -0500
Received: from mail4.hermes.si ([193.77.5.145]:3990 "EHLO mail4.hermes.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbYBKRGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:06:17 -0500
X-Greylist: delayed 1679 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 12:06:17 EST
Date: Mon, 11 Feb 2008 17:38:09 +0100
From: Rok Ruzic <rok.ruzic@hermes-softlab.com>
To: linux-kernel@vger.kernel.org
Subject: reading user. extended attributes from symlinks in 2.6 kernels
Message-ID: <20080211173809.4a2db13f@hermes-softlab.com>
Reply-To: rokr@hermes-softlab.com
Organization: Hermes Softlab
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RPg0W0xPbKX6kckH03XC70R";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RPg0W0xPbKX6kckH03XC70R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I have an XFS filesystem containing files and symlinks with application-spe=
cific EAs in the user namespace. The files, symlinks and their EAs were cre=
ated while running a 2.4 kernel.=20

In 2.6 kernels access to user EAs was prevented for symlinks. My problem is=
 that i have to upgrade the kernel from 2.4 to 2.6 series and i have to hav=
e access to all the EAs after upgrade. Is there a way to read user EAs off =
of symlinks on an XFS filesystem on a 2.6 kernel either from userspace or f=
rom a filter driver sitting between VFS and XFS filesystem code?

I would appreciate it very much if somebody could point me towards a soluti=
on.

Rok

--Sig_/RPg0W0xPbKX6kckH03XC70R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsHnzHAm5cPk3sOgRAqeqAKCZl/n2oCni9TGpaMag27uCymHAqwCgq0/f
l4+klrmF5//FbmMwZ9wRzcA=
=wQq6
-----END PGP SIGNATURE-----

--Sig_/RPg0W0xPbKX6kckH03XC70R--
