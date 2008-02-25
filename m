Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYBYLep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYBYLep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYBYLeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:34:37 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:58468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYBYLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:34:36 -0500
Subject: Re: filesystem corruption on xfs after 2.6.25-rc1 (bisected,
	powerpc related?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080225112310.GA5516@soziologie.ch>
References: <20080225112310.GA5516@soziologie.ch>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o+13gtM1ze3OhpwPt/fg"
Date: Mon, 25 Feb 2008 12:34:27 +0100
Message-Id: <1203939267.13162.93.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o+13gtM1ze3OhpwPt/fg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Git reset is just the easiest way to reproduce it.

Interesting :)

> I was able to track this corruption down to commit
> a69b176df246d59626e6a9c640b44c0921fa4566 ([XFS] Use the generic bitops
> rather than implementing them ourselves.) using git bisect.
>=20
> Reverting edd319dc527733e61eec5bdc9ce20c94634b6482 ([XFS] Fix
> xfs_lowbit64) to avoid merge conflicts and the faulty commit on top of
> 2.6.25-rc3 fixes the problem.

Odd. The replaced code doesn't look like it has any sort of endianness
assumptions.

> My filesystem is on an LVM2 logical volume and my computer is a
> PowerBook G4 (model 5,8). I'm using GCC 4.2.3.
>=20
> My problem is similar to the problem Johannes Berg reported in:
> http://oss.sgi.com/archives/xfs/2008-02/msg00244.html
>=20
> AFAIK Johannes also uses a PowerBook.

Indeed, I do, forgot to mention that, thanks for copying me.

johannes

--=-o+13gtM1ze3OhpwPt/fg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8KnwqVg1VMiehFYAQJcvw//ePAx/m2dCWUYptVRrufyOCNwIRcpzb8q
9KNNuooErqBihVp3XfXx7TWoPOEadj0dTuvaYTIsj8TLK6CijcgV+YT7mM7elvQB
HbsLctwUBLz/Sg//Q6L5WWAUaA4RaYtKvyKox9aUe9noHNQvLdntRQwvk3TbHTpj
Waejx4u+j+jPwNIna/QxWoBBhMvRp4zoHK2U+hY0zlDT0Tli+O0KNM+xjfeS1Bav
IF9uCymJudbHwdWucvcd4DWR8I1PLSHsEqp97XtYY8wrz9h735vsuFooHY1IWZL4
uK4XnoOuMHVqUaF/9S1DA3aGfnqKwEVT9A0FnjteDsEkyZPoF18LQl5pslmZBoBR
cq/cLD1J+OUWEtCUKEjk2CE9f7cVYDq5bhjUBUo+075Pa5xpnZAoaJt4ikLdpXZX
VLAYrtaNrHKQ7UuHjJlQMTy0xrBey8lt1eplzK/Pkx0qziiJyTp+T5K9eEtSMC5R
RjdyqQVwVW/VQEuzEQMCftqg+NC9TuO5i4T+iZmjIBe1sWsWnIoZiIUHP5Pzh2Bj
g0IXqhNvKIYWzB+LUZjtTrYtXjTDwAQV6qdvKc+sWwalN4vd2b0sjWc4v+EBEg78
5F8Z5NZteuP1n5ApOxCGASTU1eELwRbvOnvt2lSbgWTs9RErn7vAGlDozqhFbZ99
JrIzSUvu1OE=
=OX4E
-----END PGP SIGNATURE-----

--=-o+13gtM1ze3OhpwPt/fg--

