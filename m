Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbZKXKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbZKXKF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932572AbZKXKF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:05:58 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:59420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbZKXKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:05:58 -0500
Subject: Re: kvmmmu tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Avi Kivity <avi@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <4B0BAC76.3080202@redhat.com>
References: <1258974375.7094.158.camel@johannes.local>
	 <4B0BAC76.3080202@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z+Vfo3GnVQTiRKDzfg3D"
Date: Tue, 24 Nov 2009 11:05:30 +0100
Message-ID: <1259057130.3985.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z+Vfo3GnVQTiRKDzfg3D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 11:50 +0200, Avi Kivity wrote:
> On 11/23/2009 01:06 PM, Johannes Berg wrote:
> > Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
> > the userspace interface for tracing because of the weird
> > KVM_MMU_PAGE_PRINTK macro.
> >
> >   =20
>=20
> Can you explain what is wrong with it?

It's a big C expression that trace-cmd can't parse :)


> Is userspace reading mmutrace.h?  When the structure attributes can be=20
> exported via /sys/kernel/debug/tracing?

Yes ... look
at /sys/kernel/debug/tracing/events/kvmmmu/kvm_mmu_unsync_page/format
for instance.

johannes

--=-Z+Vfo3GnVQTiRKDzfg3D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLC6/mAAoJEODzc/N7+QmaqW0QAIM3uTLw9YsiN31K8RV8qhtx
icAyqHEPTZW3y/9ZXGQ/BiWWynt7f3bRfJrE+69SZj/q3eBzYvBTRXDaMNb/TAG9
0Uf8oq+WHQvgtx92WI0ojYwMeoo5zI5p4crxlxNdYgX/878dvlbOdZhjkc+W1ID+
tsZ22+IZyqRhl20Hl8JlxOM5uT3MUbZR+Z91nNArgA8lYVFpU63dOJxkTYQeAe0/
IKNiSD4P0/uzRjw6Ij1UKoEMawavK/r6QR9QrDTJ9jFiRegDZfY5/x4QXxJ4uEMh
Q3SwDdgrIYkYj/NpdEfuKUeq8PaDQVl7eYj4GYh1Qw7xTqNJUxhvyuFazD+TH6gI
DSJWVUdURqwnhv5yPKo9fasmJm6cQ5nTUM4N9MVel4W4dbGCdv63SAAIOrnOM7lu
hUtOoP8Q3ww/jnGGEP5CEVBalpjkL+zcq3OYFgUXTUac4aGDRGbsJgP/q6KQmI1t
AEXsGgQP3mn2u0nK6MEBZ53eLBPU9XomssRiEGmpaRNLhSgaGeFT0MFq2QINGkWk
K5rqFzSrn9IJxOuAYcou8i6OZfJxYwrLpuipF5XqakrI6n0zO3bf5TJb2yMzSA2l
wcjJa2+7seRHnF5KS+EyGHAsTX0ZSQ+/gy/eCZOTGZfG/L1fQFjenu8DtU7Dyglo
uIvD6fXOlXJ/1QoAHVnU
=NUqo
-----END PGP SIGNATURE-----

--=-Z+Vfo3GnVQTiRKDzfg3D--

