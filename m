Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbXGOVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbXGOVmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbXGOVmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:42:24 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36609 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667AbXGOVmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:42:23 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Jonathan Campbell <jon@nerdgrounds.com>
Subject: Re: Patches for REALLY TINY 386 kernels
Date: Mon, 16 Jul 2007 07:42:24 +1000
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, torvalds@transmeta.com
References: <469A8AED.7070207@nerdgrounds.com>
In-Reply-To: <469A8AED.7070207@nerdgrounds.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2943614.sK4JJzgS6a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707160742.25232.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2943614.sK4JJzgS6a
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jonathan.

On Monday 16 July 2007 07:00:29 Jonathan Campbell wrote:
> I wrote a set of patches out of concern that even if you compile a 386=20
> kernel a lot of code irrelevent to legacy machines still remains. Things=
=20
> like the Pentium TSC register, DMI information, ESCD parsing, and the=20
> use of CPUID do not apply to these machines, but looking at System.map=20
> you can see they're still there.
>=20
> Already with these patches I can compile a zImage kernel that is 450kb=20
> large (890kb decompressed) with a small initramfs payload, floppy and=20
> kernel module support, FPU emulation, that can successfully boot on an=20
> ancient 386 laptop with only 1MB of extended memory. Eventually what I'd=
=20
> like to have is the ability to compile a pure 386 kernel with all=20
> non-386 functions removed (and perhaps the same for 486 machines).
>=20
> These patches were written against the vanilla 2.6.21.1 kernel. They=20
> will have no effect UNLESS you make menuconfig and explicitly enable=20
> them there.

Would you please make mrproper before preparing the patch? It's harder to r=
ead=20
with all the "Only in..." lines.

Regards,

Nigel

--nextPart2943614.sK4JJzgS6a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGmpTBN0y+n1M3mo0RAhbZAJ4rfhMwfP2R9EGYt4P4JHmpko5fugCg6yJ3
4k48YgMJxuEetnjrgBjIB7o=
=FXRC
-----END PGP SIGNATURE-----

--nextPart2943614.sK4JJzgS6a--
