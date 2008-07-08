Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYGHSjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYGHSjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYGHSi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:38:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbYGHSi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:38:57 -0400
Subject: Re: [RFC 07/11] remove CONFIG_KMOD from sound
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080708183027.GB11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net>
	 <20080708170046.726427000@sipsolutions.net>
	 <20080708183027.GB11954@cs181140183.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9d7425L+IenyLYMALLLM"
Date: Tue, 08 Jul 2008 20:38:13 +0200
Message-Id: <1215542293.3670.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9d7425L+IenyLYMALLLM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 21:30 +0300, Adrian Bunk wrote:
> On Tue, Jul 08, 2008 at 07:00:22PM +0200, Johannes Berg wrote:
> >...
> > --- everything.orig/sound/core/seq/seq_device.c	2008-07-08 18:54:05.000=
000000 +0200
> > +++ everything/sound/core/seq/seq_device.c	2008-07-08 18:57:40.00000000=
0 +0200
> >...
> > @@ -566,7 +566,7 @@ EXPORT_SYMBOL(snd_seq_device_load_driver
> >  EXPORT_SYMBOL(snd_seq_device_new);
> >  EXPORT_SYMBOL(snd_seq_device_register_driver);
> >  EXPORT_SYMBOL(snd_seq_device_unregister_driver);
> > -#ifdef CONFIG_KMOD
> > +#ifdef CONFIG_MODULES
> >  EXPORT_SYMBOL(snd_seq_autoload_lock);
> >  EXPORT_SYMBOL(snd_seq_autoload_unlock);
> >  #endif
> >...
>=20
> You can remove the #ifdef =20

Same here as with dev_load, unless it's actually ok to export static
inlines.

johannes

--=-9d7425L+IenyLYMALLLM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc7QRAAoJEKVg1VMiehFYAZUP/2IihYSUL8sopsJ7COcwHCra
l8P47aEMML/Agfu69AKJJdgNaDZd4v73mSD7CqeBy0IX7CS+VbDjF6gj5B8lS+Sm
6bzNkU0XYV/2HKwwLa1sMm/0ZiPKBVfB1IXVLOvxw0+F26SxSSVDGTiEzBCmCDJL
o/sOfnfJH2FVLqMtJy2tMuOJUnIvh9Zh2JnV8c8GbYzCjUN836KJBebIsqOCuAaS
1apUPNvKe1lxgyhWsgLIgixebC4iYmQci2eo9FTWWgp6mAOASWVOJcgj5e/5bCnc
ZPBRhsupl+XGnD+3jxOqdiuS8ZzeLi5NooMWvOmjEYuxLBDWVccJT2ZpenSWw9hw
QAAEe9nYzUSFuq2MBWyMqFxH1c1JrxubCvlHpJA6LqwJHdwLMarDWwDZsZ/NALsX
YsbG40Q/rG88oGGQVVP7S/FawsY9nYVDIPqi7edc7VxHBQPL6raB7EB72VR0oaqZ
rrkq63LFFwZVfqZmedhMtVQq7vd+X+G3gHDbPlUqhpt+1EO6jqysvA9WSOyCtMCy
nsWDkNQmDR4GPA+OGbUE2CPZGjpc2ERVCB8KHI65o/iLGm48OFY06qHf2yqS8n0x
ZhBDnxLGDVBrIOjTsytPHByKnFNGQ99Z+JvQ9h4GkKNwy6sBNiQzqwaut+n9nXWx
lFFxE3aeWhlcm9Yv1qoR
=RwDs
-----END PGP SIGNATURE-----

--=-9d7425L+IenyLYMALLLM--

