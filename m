Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZLSLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZLSLmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZLSLmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:42:14 -0500
Received: from k66.ru ([87.224.128.21]:54578 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZLSLmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:42:13 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 06:42:12 EST
Date: Sat, 19 Dec 2009 16:12:06 +0500
From: Andrey Rahmatullin <wrar@altlinux.org>
To: linux-kernel@vger.kernel.org, Roger Luethi <rl@hellgate.ch>
Subject: via_rhine kernel crashes in 2.6.32
Message-ID: <20091219111206.GA5307@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

Recently I've started to experience kernel crashes under heavy network
load. It may be caused by switching to .32-rc0, but as .30 crashed too, it
may be caused by switching from Vuze to Deluge (maybe it uses the network
more actively). Unfortunately, most crashes can't be detected with
netconsole, and they usually don't fit into 1280x1024 (I think the kernel
prints 2-3 or more backtraces of random processes like hostapd and scmpc
and then completely locks up). Here are two screenshots that look like
complete one-screen traces:
http://wrar.name/temp/P1010714.JPG - this is from .32-rc0
(v2.6.32-7123-g75b0803)
http://wrar.name/temp/P1010711.JPG - this is from 2.6.30 (stock ALT Linux)

Of course I have lots of "eth0: Transmit timed out" and some "WARNING: at
net/sched/sch_generic.c:255 dev_watchdog" before crash, as described at
http://bugzilla.kernel.org/show_bug.cgi?id=3D11663

--=20
WBR, wRAR (ALT Linux Team)

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLLLUGAAoJEOih81koZvPBme4H/1GXbQPtakc219sQjXcM9sZF
MIOtasoIUBHgZCd433ebGWbAW5IQwDgKt/K9QM24Bv+B2kONsG+g1yMjJF543lQZ
8UcoG8pdFN11IrED5EFOtR6Ql2BX15Jw4maUcw1+g8wLHOvO+37M9t7cODxGl354
bMJYOPj7JZppjNkCuJeLrMdVNoaC2cUpoY6Bdui/uT7xEcIgOn2xlsHzCLyo2ynQ
NQ5+egoFVGjj+T1pZ3uKDIq2xqcemRZC5L0lJfrSKBiEtWowQ5p6kw1kFX7EBhGt
9W53scjSboJS17Vd98IzPvtT5QOOFBQTHOnB6tdO5989WklUKMlpv1D8zN4HN7c=
=FO6P
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
