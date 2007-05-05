Return-Path: <linux-kernel-owner+w=401wt.eu-S1423166AbXEEPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423166AbXEEPko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423174AbXEEPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:40:44 -0400
Received: from iucha.net ([209.98.146.184]:50654 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423166AbXEEPkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:40:42 -0400
Date: Sat, 5 May 2007 10:40:37 -0500
To: Neil Brown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: REGRESSION: cannot change file access permissions on files NFS-mounted
Message-ID: <20070505154037.GA5459@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

This morning I updated the kernel on my workstation to the current git=20
tree (62ea6d80211ecc88ef516927ecebf64cb505be3f).   Upon reboot, I
cannot change file access permissions of files in a directory that is
nfs mounted (using NFS4):

   $ chmod 0600 $path
   chmod: Changing permissions of `$path': Input/output error

In the kernel log I am getting these gems:

   [  275.990233] decode_attr_group: reply buffer overflowed in line
   2678.<4>decode
   _attr_group: reply buffer overflowed in line
   2678.<4>decode_attr_group: reply bu
   ffer overflowed in line 2678.<4>decode_attr_group: reply buffer
   overflowed in li
   ne 2678.<4>decode_attr_group: reply buffer overflowed in line
   2678.<4>decode_att
   r_group: reply buffer overflowed in line 2678.

The server is Linux running Debian testing with the kernel updated to=20
2.6.20-1-686 from
(http://ftp.us.debian.org/debian/pool/main/l/linux-2.6/linux-image-2.6.20-1=
-686_2.6.20-3_i386.deb)

Kernel 2.6.21 works fine on the client.

Cheers,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGPKV1ND0rFCN2b1sRArY9AJ4gt23+sD9TIET6g0+ORcXl5L7vzgCeOX2k
6D7Dz0tZ0MS7AfBN+XR6Dvw=
=HlVo
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
