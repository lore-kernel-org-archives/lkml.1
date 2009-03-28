Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZC1KqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZC1KqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 06:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZC1KqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 06:46:15 -0400
Received: from main.gmane.org ([80.91.229.2]:57739 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZC1KqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 06:46:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: cpu temperature after wakeup
Date: Sat, 28 Mar 2009 11:45:54 +0100
Message-ID: <gqkv57$5e8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18499FD778D577E1A928322A"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 85-127-253-53.dynamic.xdsl-line.inode.at
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18499FD778D577E1A928322A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi all,

after a wakeup from suspending to ram, the cpu temperature (reported by
acpi) for the second core is about 15=C2=B0 higher than for the first cor=
e
(core2 duo t7400, x86_64).
i am not sure, if it is just an issue of reporting the wrong value or if
the cpu temperature is actually that different.

on a more or less idle machine: cpu0: 44=C2=B0c, cpu1: 60=C2=B0c
doing some work:                cpu0: 55=C2=B0c, cpu1: 70=C2=B0c

any idea, what could be the reason? usually both temperatures are quite
similar, after a reboot, it seems to be fine again. i am running 2.6.29,
but i think i already saw it on earlier kernels, i didn't look into it
at that time, though ...

thnx, tim

--=20
tim@klingt.org
http://tim.klingt.org

The aim of education is the knowledge, not of facts, but of values
  William S. Burroughs


--------------enig18499FD778D577E1A928322A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknN/+YACgkQdL+4qsZfVsu/VgCgldT5sUHBKhEjaU/XyCvtrwbs
ixAAn1OpAPAFe41QL61uF59gYzWHYi08
=npp+
-----END PGP SIGNATURE-----

--------------enig18499FD778D577E1A928322A--

