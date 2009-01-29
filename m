Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZA2QZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZA2QZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZA2QZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:25:45 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51569 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZA2QZo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:25:44 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded - docking station issues.
In-Reply-To: Your message of "Wed, 28 Jan 2009 02:19:09 PST."
             <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233246343_3709P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jan 2009 11:25:43 -0500
Message-ID: <20830.1233246343@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233246343_3709P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jan 2009 02:19:09 PST, akpm=40linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
>=20
>    http://userweb.kernel.org/=7Eakpm/mmotm/

% ls -l /sys/devices/platform/dock.0/docked
-r--r--r-- 1 root root 4096 2009-01-29 10:49 /sys/devices/platform/dock.0=
/docked
% cat /sys/devices/platform/dock.0/docked
=F1=DEcat: write error: Bad address

strace of the cat shows:

open(=22/sys/devices/platform/dock.0/docked=22, O_RDONLY) =3D 3
fstat(3, =7Bst_mode=3DS_IFREG=7C0444, st_size=3D4096, ...=7D) =3D 0
read(3, =22=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=
=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=5C0=
=22..., 4096) =3D 1812586496

Under 2.6.29-rc2-mmotm0116, this would return either =220=22 or =221=22, =
not 4K
of nulls.

--==_Exmh_1233246343_3709P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJgdiHcC3lWbTT17ARAnkkAKCIUM3/iIV4pIel+VUT1tBW2afpDgCg+C6W
s7CkKV4qXWamGx35jGi/knI=
=d+7d
-----END PGP SIGNATURE-----

--==_Exmh_1233246343_3709P--
