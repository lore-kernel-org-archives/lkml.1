Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXK0NJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXK0NJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbXK0NIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:08:55 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:59325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbXK0NIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:08:54 -0500
Subject: Re: time accounting problem (powerpc only?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Mackerras <paulus@samba.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <18251.59930.30260.145217@cargo.ozlabs.ibm.com>
References: <1195814816.4149.94.camel@johannes.berg>
	 <1196094193.4149.287.camel@johannes.berg>
	 <18251.59930.30260.145217@cargo.ozlabs.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zmq9eWgfEu3L6rEL1fof"
Date: Tue, 27 Nov 2007 14:06:20 +0100
Message-Id: <1196168780.6058.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zmq9eWgfEu3L6rEL1fof
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-27 at 20:57 +1100, Paul Mackerras wrote:
> Johannes Berg writes:
>=20
> > Contrary to what I claimed later in the thread, my 64-bit powerpc box
> > (quad-core G5) doesn't suffer from this problem.
> >=20
> > Does anybody have any idea? I don't even know how to debug it further.
>=20
> I see it on my G4 powerbook.  However, a compute-bound task runs just
> as fast (i.e. completes in the same elapsed time) as on older kernels,
> so it does look like it is just an accounting problem.  If the CPU was
> really spending more than half its time servicing hardware interrupts,
> the task should take more than twice as long to complete.

Exactly. So where do I look for the accounting bug?

johannes

--=-Zmq9eWgfEu3L6rEL1fof
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0wWS6Vg1VMiehFYAQKiEQ/8CzIJN0rF3Z/YUtKOUIjHJbCIhIDH1GJM
LEhnKtuX7RhS2L5cGxzxn6e8ipeNK4RBlTtYchk09AeYo1wUS+R94Is2afA+y8Fz
idztJuL7w6nHy/j1QVe2+45cSLJnWMgzimko7kY3FAASUk4875zqalRkR/+AAAkg
GklPh0IJALa06hXPpB6HZQCtKpQDlPoy0yWzxeUQlpl2NHDrNdScBkUhB1wzxPea
81C3j0yCp9u9S3EtfbOWezta9MerQ6ps3+J0m+3VyjzGb3HeucPwU2NA5rM8Lbkx
it1Mei8hi2hgZp+HNMdcWNdQWkfJXI3D9h1jkHrvC67qRRIYpIYmidKkNp16nvHR
+FFUmfFG8RkzD0Q/NykQeSR48Os3E7jDP65z/Song/9b4LHx9GUu1UunnzAY8lTg
zcBF+6axcq0ycyre5TrkaOK04CBtRF+qRba4wrB/ocJXDBBujMjDCo//c9NSY3gu
uV/xOEPkRNoncUrbGKIKmSd29BFoYtmKWA5tCJIaaA1FBiU6oyft3wPWc4vyWouj
R+xfTWs/RtFMgujQIqr8zJ8+nm0iPc4rFvXPIwuuLEA2CLFNLCc1osWXeJ6nr1Ds
JTYN9eqSOZ7ZpUhrD7Kjzvd5NP6wiUObKNHFDzinfiGX+d+oGCL5XyDQ4sO5deZ/
olDdUe6a+wo=
=bllv
-----END PGP SIGNATURE-----

--=-Zmq9eWgfEu3L6rEL1fof--

