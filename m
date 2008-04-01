Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYDALvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYDALvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYDALv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:51:28 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:45341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYDALv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:51:27 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20080331190509.GA2876@atjola.homenet> (sfid-20080331_200545_586850_F9F614C8)
References: <20080330184259.GB21375@atjola.homenet>
	 <20080331190509.GA2876@atjola.homenet>
	 (sfid-20080331_200545_586850_F9F614C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bPVMUvJEH0d3UrMegwqp"
Date: Tue, 01 Apr 2008 13:51:18 +0200
Message-Id: <1207050678.5143.43.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bPVMUvJEH0d3UrMegwqp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 21:05 +0200, Bj=C3=B6rn Steinbrink wrote:
> On 2008.03.30 20:42:59 +0200, Bj=C3=B6rn Steinbrink wrote:
> > I can't reproduce the bug on my UP box and currently can't afford
> > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > guess it needs SMP to crash), so while this doesn't show any new
> > problems, I can't tell whether it actually fixes anything. Testers
> > welcome!
>=20
> Hm, crap, can't reproduce on my x86_64 SMP box either. Tried with
> various preemption models as well as rcu classic and preempt. Johannes,
> is there anything "special" in your configuration?

slab debugging turned on by default? without it, you'll most likely
never notice.

johannes

--=-bPVMUvJEH0d3UrMegwqp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IhtKVg1VMiehFYAQKsxRAAk/ofH+a5LA+hcnCkKNXjEtvPdcWy9vZk
32BXU4HSupf7Xi9A+UCUDQ0JkFr6CzTBAwM8r10rvWHxtMx4puNZsNSl2Nvw1PXD
9R/AuSRp4/t4AHrkClOleEfsccRMOLXtxr0WyKGj2oidBXtQLjG7zbG6PBVnwCFf
GiWGLGHj7JNrqglICrHPBA707/71yrRwfb3qQEk5PORXQLZicEHiUmEKV6XTO247
TWsDFQa/M3hEWq49aU0cXsH9k/Cp+wkpnxNIrdNwRXnvhBuCXfsmpbDApUnxom9E
1pKybL1reHKdY85/JflwsDH8nCT94Gd5ejQTYAbqvP0ctxhZWDkgOGRDCJr50FJr
PVvV9ktqFlgJCKWpHD99BFhLeycn7FYJNQWpgiKbCj1kxdj7ByQX3JrSLU0gP5pD
DLJXabA43yeEQ4A5N64+edKnN/8zd0DU6AcZViXfVmjFiAVX5VlvQrdQm3B79j/8
BxrqChS7f+5S/qY9y0z5JSw7hKla7e8lGSikBVzOey+s81Zm4DwFdpAaqpqeK+um
1HIY3qfjV7cjBJ3c2Sn7H7RYwXqFZ/4x8cd0TaC2KPJF2CIuwhy976wAVQZSOd6l
vdXVGIZZhCR0FTzTbukPKHzee3lOX0JYYYGN7zXtliZ3mrvDWNaJw1/QWwvBIAX+
rY0mmwYSNgY=
=eMzb
-----END PGP SIGNATURE-----

--=-bPVMUvJEH0d3UrMegwqp--

