Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZERSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZERSKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZERSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:10:39 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZERSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:10:38 -0400
Subject: Re: iwlagn broken in next-20090514 and next-20090515
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1242669029.3845.0.camel@localhost.localdomain>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	 <20090515102621.GA5735@ikn.schottelius.org>
	 <20090518171505.d30d2f64.sfr@canb.auug.org.au>
	 <1242662635.32358.523.camel@rc-desk>
	 <1242663867.27425.1.camel@johannes.local>
	 <1242669029.3845.0.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i8SXLxaQQ7sxr8I7S6Ul"
Date: Mon, 18 May 2009 20:10:11 +0200
Message-Id: <1242670211.29049.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i8SXLxaQQ7sxr8I7S6Ul
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 13:50 -0400, Dan Williams wrote:

> > > > > Also wpa_supplicant is not happy:
> > > > >=20
> > > > > + wpa_supplicant -B -Dwext -iwlan0 -c /home/user/nico/ethz/wlan/w=
pa_supplicant.conf
> > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > >=20
> > >=20
> > > There were some changes recently to this ioctl, but I am not familiar
> > > with details. Johannes will know.
> >=20
> > Yeah, I'm not sure -- this happens when clearing keys. I'll look into
> > it, we probably need to accept removing a key that doesn't exist.
>=20
> Why bother (if that's actually the root cause)?  Maybe the supplicant
> should be fixed.  Other drivers return ENOENT in this case, so mac80211
> certainly isn't out-of-common-spec here now.

I just looked at the code in wpa_supplicant, it doesn't care a bit, just
prints the error. Problem is users attribute any other breakage to the
error it prints since our behaviour changed...

johannes

--=-i8SXLxaQQ7sxr8I7S6Ul
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEaR/AAoJEODzc/N7+QmaFDwQALPZYNroPlpvJ9vwiq7d93cf
lz9rwq3n6mHdpKyWcCE2zRadwgVd73hy/A3n3KaNtCawwOqXZ8TJmG/wnjtkXf1b
19JNzgY4k8Ue4P9p6gFc04tRCY+3QdlLIQO4QZd2KaIuQxtAxpG+nl/zW4mVnYId
8a5eLFkvCWxS9ZnlV1zUrjRvfSwbhYDTW8zwqFvLLgReR/WL9x5wENBk01LWstd2
R7+Kv65dHbe5S7Rfmy4qlhrJ/ZcabNkcgfdMl/GUKE633+lcqPN/rpttCvtOqcbu
H2oCGISHBUT0rCB6j1BVFIrzHdQbHpI8Y8UpDVyvwp/9etjcXLQGTNWj/16Yshkt
U/FAu/O5hqiYFA+saLThl5ZktKzTMP77bCqgqc2RUJ8Jz24WMmCpd2SI5Jbi54iz
Bez7meawFOnIUyg2Ob9VmuQXQ703Fuve9Ui/O8LDMqpXwDThu/Ry7oXuy5zIP7au
lgSDLM5MDtGETlnCC3aSkD8SEaZ1KpC1BCEWUa2bPyuigD7N77yvZv9hQlZRaM3k
4J7noCoSCcG7U+Y3KCs4+wrnwNDhKMnqCNJoDA64l3jkK9HEJBz5fhMU8A1kSKHB
AmnJXK9X0lDk5D84FYDLCsgfj/g5OGoyeGGhMn5ERPBo6tWzRbTAcG5+RjEWHqDg
s/sb39Kai8+pbIxE1Nuy
=Trbe
-----END PGP SIGNATURE-----

--=-i8SXLxaQQ7sxr8I7S6Ul--

