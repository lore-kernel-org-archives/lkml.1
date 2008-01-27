Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYA0SP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYA0SP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYA0SPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:15:16 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:52784 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYA0SPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:15:14 -0500
Message-ID: <479CCA28.90806@web.de>
Date: Sun, 27 Jan 2008 19:15:04 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] KGDB: refactor kconfig menu
References: <479CA7CE.8040407@web.de> <479CC6E7.4000103@windriver.com>
In-Reply-To: <479CC6E7.4000103@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA51095529970447B9D8C2791"
X-Provags-ID: V01U2FsdGVkX18lPzmCZBSjypvpzKEmYlXncaYHhm045OMAFE5X
	W9+NZzFSxILlgoKNzf8FDhye6lXi+aMknJxuuFdTlX9td0m0lf
	PwG8LsWa8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA51095529970447B9D8C2791
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> Jan Kiszka wrote:
>> This is an attempt to improve the so far, well, unfortunate Kconfig me=
nu
>> organization of KGDB. Most notably, it pushes all sub-entries into the=
ir
>> own menuconfig, removes the (IMHO) unneeded "Method for KGDB
>> communication" choice, and ensures everything is indented properly. Th=
is
>> should keep the original semantic while reducing the number of knobs t=
he
>> user is confronted with.
>>
>>  =20
>=20
> While it is probably reasonable to put the kgdb options into a sub
> entry,  you cannot get rid of the "Method for KGDB communication"
> choice, unless you re-implement it another way.
>=20
> It is designed to implement the following:
> 1) You can chose to build 1 and only 1 KGDB I/O module into the kernel
> 2) Or you select modules only and can you can build as many additional
>     KGDB I/O modules as you like.
> 3) Additional I/O modules can be built and you can load one at run time=

>     if you want to use another I/O method vs #1

I see no reason why these cases cannot be enforced later on (when there
are >1 I/O modules) via Kconfig depends-on rules. But maybe I'm
overseeing something, please correct me.

>=20
> KGDB's Kconfig options are designed to allow you to have alternate ways=

> to select static or run time configuration of the I/O connection to the=

> KGDB core, IE: over serial, over ethernet, over USB or what ever module=

> you would like to implement.

Well, I'm looking at this from the user perspective now, and as a user I
don't understand why I shouldn't be able to configure my setup via the
tristates of the involved I/O drivers (+ some underlying dependencies).

Jan


--------------enigA51095529970447B9D8C2791
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHnMowniDOoMHTA+kRAurcAJ9ES9MDSDXazdYfWI6OZ876T80y5wCfSYRU
4VoHPzZ2IhlKTv2QH6VkdjM=
=VxC1
-----END PGP SIGNATURE-----

--------------enigA51095529970447B9D8C2791--
