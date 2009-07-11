Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZGKRDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZGKRDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZGKRDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:03:30 -0400
Received: from mx33.mail.ru ([94.100.176.47]:28512 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZGKRD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:03:29 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: How to monitor Linux NFS client load?
Date: Sat, 11 Jul 2009 21:03:23 +0400
User-Agent: KMail/1.12.0 (Linux/2.6.31-0.rc2.5.3mdv; KDE/4.2.96; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1643450.1QxvPtLl5q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907112103.27082.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1643450.1QxvPtLl5q
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Recently we have the case of very high latencies on NFS reads as=20
reported by application (SAP R/3). NFS server was NetApp FAS; according=20
to NetApp statistic, average volume read latencies were in order 10ms,=20
while SAP stats gave 30-50ms. Systems were interconnected by dedicated=20
1Gb/s Cisco switches (3750G) with ca. 30% max load on interfaces.

On advice of my colleague we changed sunrpc.tcp_slot_table_entries from=20
default 16 to 128 which seemed to make situation much better - without=20
changing load pattern of filer in any visible way.

Now, I can understand, why we observed much higher latency on system and=20
why changing (what effectively is) queue depth helped. But I am totally=20
frustrated that there does not appear to be *any* possibility to detect=20
this situation on Linux side and to get a real numbers of real NFS IO=20
latencies or number of requests waiting to be executed (and I do not=20
even dream about per-mount point stats).

I am grateful for any hints how can we monitor Linux NFS client and get=20
real-life numbers of what happens inside. Thank you!

=2Dandrey

--nextPart1643450.1QxvPtLl5q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpYxdsACgkQR6LMutpd94zlhACbBrZXuthSX0JHia0msHfJx5Gp
EHoAoJOddoM2KNJfS4yysIxWuOyRQWzf
=Co50
-----END PGP SIGNATURE-----

--nextPart1643450.1QxvPtLl5q--
