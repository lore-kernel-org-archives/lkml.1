Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZGHLmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZGHLmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZGHLmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:42:02 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:55912 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZGHLmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:42:01 -0400
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Scott James Remnant <scott@ubuntu.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Peter Jones <pjones@redhat.com>
In-Reply-To: <21d7e9970907080420h41375e36q1efacb9f3555b9de@mail.gmail.com>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
	 <20090623144221.GA29593@suse.de>
	 <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
	 <20090623153928.GA32604@suse.de>
	 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
	 <ac3eb2510907080403h14e5597eu3dee309456eab17e@mail.gmail.com>
	 <21d7e9970907080420h41375e36q1efacb9f3555b9de@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3ZGNBgZcbkPoQv+KtLSo"
Date: Wed, 08 Jul 2009 12:42:24 +0100
Message-Id: <1247053344.12859.29.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3ZGNBgZcbkPoQv+KtLSo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-08 at 21:20 +1000, Dave Airlie wrote:

> On Wed, Jul 8, 2009 at 9:03 PM, Kay Sievers<kay.sievers@vrfy.org> wrote:
> > On Wed, Jul 8, 2009 at 12:54, Dave Airlie<airlied@gmail.com> wrote:
> >
> >> Okay can we revert this for a better reason? it seems to have unhidden=
 a race
> >> condition on booting some of my machines. I've booted some other machi=
nes
> >> with the same USB disk and the same kernel fine.
> >
> > Are you sure? USBFS is for userspace USB drivers, booting from
> > usb-storage devices should be fully handled by the kernel.
> >
>=20
> Yes, changing just this option means the difference between a bootable
> and stuck in initrd system. maybe Peter knows if our initrd does somethin=
g
> otherwise I suspect we have a race that usbfs was hiding.
>=20
I assume you're not using libusual or anything like that?  We had a race
caused by libusual calling modprobe before we'd generated modules.dep

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-3ZGNBgZcbkPoQv+KtLSo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpUhh8ACgkQSnQiFMl4yK65dwCgi3zrJuE/QISisTw2JSEOp/Pq
f+wAn39A+hssib6AYn25fkz7jesmUrpO
=z+P6
-----END PGP SIGNATURE-----

--=-3ZGNBgZcbkPoQv+KtLSo--

