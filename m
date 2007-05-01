Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXEAOQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXEAOQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXEAOQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:16:41 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43370 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbXEAOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:16:33 -0400
Message-ID: <46374BB6.9080703@web.de>
Date: Tue, 01 May 2007 16:16:22 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rafal Bilski <rafalbilski@interia.pl>, Dave Jones <davej@redhat.com>
Subject: 2.6.21: longhaul freq-scaling broken
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7766E10D61CA91A4E69C36A6"
X-Provags-ID: V01U2FsdGVkX18WRffQQpdGjW0IAkG99rZ6ZtRrIzati7cKGMJx
	sXvbJHXSLhKr1qVjD3NDGJfl2rGJ/gltfePB8xlPsabf1dkx3Z
	xJG+LcRww=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7766E10D61CA91A4E69C36A6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

the new longhaul driver of 2.6.21 is broken on my Via Eden board.
Frequencies can no longer be switched by whatever governor.

# cat /proc/cpuinfo
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 7
model name      : VIA Samuel 2
stepping        : 3
cpu MHz         : 598.000
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de tsc msr cx8 mtrr pge mmx 3dnow
bogomips        : 1200.75
clflush size    : 32

I ported the longhaul driver from 2.6.20.7 to 2.6.21, it works fine.

Yeah, I know there are only a few patches between both, but I would like
to reduce the test cycles to a minimum. Any suggestion where to look
first is welcome therefore, ready-to-apply patches even more...

Thanks,
Jan


--------------enig7766E10D61CA91A4E69C36A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGN0u2niDOoMHTA+kRAmMGAJ9fJc3p0/pZb0EE+IRkbTnUqIUhkQCfQJaC
JnfmURkmA+B84BodR9uU1Nk=
=4Kpr
-----END PGP SIGNATURE-----

--------------enig7766E10D61CA91A4E69C36A6--
