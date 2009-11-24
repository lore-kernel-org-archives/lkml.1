Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbZKXOJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbZKXOJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbZKXOJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:09:01 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:40743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbZKXOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:09:00 -0500
Subject: Re: kvmmmu tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Avi Kivity <avi@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <4B0BB6B1.5010302@redhat.com>
References: <1258974375.7094.158.camel@johannes.local>
	 <4B0BAC76.3080202@redhat.com> <1259057130.3985.1.camel@johannes.local>
	 <4B0BB6B1.5010302@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qas+jHorQMy+/cBIJlOr"
Date: Tue, 24 Nov 2009 15:08:33 +0100
Message-ID: <1259071713.3491.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qas+jHorQMy+/cBIJlOr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 12:34 +0200, Avi Kivity wrote:

> Um, C can be easily parsed with a C compiler.  I don't think you can=20
> expect it to be a plain format string and argument list.

Actually, it turns out that it cannot be parsed even with a C compiler:

({ const char *ret =3D p->buffer + p->len; static const char *access_str[]
=3D { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union
kvm_mmu_page_role role;

...

userspace cannot possibly know from this what "union kvm_mmu_page_role"
is.

johannes

--=-qas+jHorQMy+/cBIJlOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLC+jeAAoJEODzc/N7+QmahSUQAI6j5lriYf05ULbhIrrp/S8k
QUuzMUlpqF7ubvTvAnG7jUuVVRdZo3itUYRDyVUbVNZXnBvvTofl4LQfCAX/rRIl
UZqmVFHiwvsMIbOviZmX/OkmdvnnUjeGCG2X4zdtgOFl/85wU6OM9IAsyc03pqXk
YNDCSQCN/seuDx7pCyw6vDj4E3L4gGxxL8Kksm4g2So7b8GApe7opsmmuS38CMmO
PAS3UpuQn9Qjqfk3KirCSNc+A2U5Jh5wANTHdVfNbtxkBiV/Wyd4NU+ZVRBP/4+1
Q4b42ZbcyHqIdFP0Z2l110G8NYk0cU7P/vrABAJfLiUdJIF/mPZcHteTILnBk7QY
Af8VGwi1wkmKFPmYO3uujJfc8hnMCAYI5hkxKPl+MDzTODPGdG7aBhNpjE5jE48L
FUuG339CwsdabTgzsOCFmbIm5Am4fdgF43z2x3fVjBO5Dgn4DC7lN44XvY0GiiVZ
WhUxUCYc3R8wAGg+2c9OS4/sG5DygoXhkExvKgy5mHpLL7tNdrZf1FsUvS5DXNmR
1b2tB5B3enzkX5AVsEpexzCrUyM7s/GGBbQw4TITxJkLX1TVI8KbVGXxnr36aDOQ
aMdinVqBY+C8EJnk6EqHUqjFQOZuLRJTXYKGWpr4YvuKiHly5e297LDqqCdoTkpp
4v3qQukYGELUQ1Or0C4C
=fNMy
-----END PGP SIGNATURE-----

--=-qas+jHorQMy+/cBIJlOr--

