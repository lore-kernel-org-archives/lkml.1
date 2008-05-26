Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYEZJJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYEZJJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYEZJJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:09:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYEZJJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:09:36 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
In-Reply-To: <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
	 <1211642706.31212.85.camel@shinybook.infradead.org>
	 <1211643245.31212.88.camel@shinybook.infradead.org>
	 <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
	 <1211707837.17151.14.camel@johannes.berg>
	 <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	 <1211716784.17151.19.camel@johannes.berg>
	 <54EDAF0A-907B-46D0-925E-56ADDA37E106@holtmann.org>
	 <1211722835.17151.24.camel@johannes.berg>
	 <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dlM6ZRJ9yWnqkQkXfIiQ"
Date: Mon, 26 May 2008 10:57:18 +0200
Message-Id: <1211792238.17151.46.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dlM6ZRJ9yWnqkQkXfIiQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> Look at the device nodes. The kernel has mouse0 for example and udev
> >> will translate this into /dev/input/mouse0. Nobody expects the kernel
> >> to use input/mouse0 and actually you even can't do that at all since
> >> the device model forbids "/" as bus id. Same applies for the firmware
> >> filenames.
> >
> > No, it doesn't.
>=20
> please enlighten me how you can use "/" within bus ids.

Please enlighten me why you need to use the firmware key in the bus ID.

> So you actually do know how request_firmware() actually works right =20
> now? You need to change the firmware_class implementation and API to =20
> give it an extra parameter to allow any kind if simultaneous loading =20
> within one driver.=20

Yeah, the API change required is internal and rather trivial.

> Having the FIRMWARE as environment variable is =20
> actually suboptimal.=20

Why? You still haven't given any reason for this.

> You want to have the FIRMWARE environment =20
> variable as bus_id for the firmware struct device object.

Why?

The way I see it, there's nothing stopping you from creating firmware
"devices" using a simple increasing number as the bus_id, and having the
firmware key be presented in a 'FIRMWARE' property of those devices.
Then, the userspace loader realises such a device is created, looks at
the firmware property, takes the firmware, and stuffs it into the 'data'
property. It doesn't matter how many there are outstanding at the same
time because one userspace process is invoked per firmware device, hence
per ID.

johannes

--=-dlM6ZRJ9yWnqkQkXfIiQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDp7baVg1VMiehFYAQIKURAAs2CglCSPr+0UuAGZQ+EXUBSYX4RIBBKS
YPalIek5S8yvcYniPyzRDoRNZzOTU/FjSfWUgrEbYR8IK2EmxZq/kOTpMR8u2fzk
ELVvhx6RGWV7yw9sHwugMrO2Qlf69uW/PB4cRafLo9K8EMrgtiXpiM6FEn8PL9SY
dt1YMIg6d6VqLbxdhdYuJxRVazDvzqW94gdSgXTVdVBh463UtwLXKF311ux6c5uv
krNokUgVvYX9Bf9CjIqcokv/1UEaKKuDVE6KpWSXk6cOB3XyKQdVR2ZIRPzUC1ES
VNZNkAjujD7xALdJlosUkmtd7ioqtoD4EP07pkJbzw44DczVIv5X/OJdmPB1WG0z
TXoryyfSw4ImXxiyJD04BhSbtWbR4Sj+6Jlvy4v++hCubTayEO8SbUyjHAc536TE
d+DmBIerkVjSnT1dmtXr3u1x6P+Lz5Mgzio2SOtapmwQazumNd8G5QZkgaJ9WniY
Rhmj1YV/uzfAywGRS+JO5C57sdwDx09gCnWYS0DDjBHG7FvnII8MN6elBlnn1RWW
q7rkOjk134PuHiIQbdJKQ7L8KWTKJ+oUN6ne+g4SNneWoF5HY9TL6N7FOEwjswHZ
1JrET3zEFzVlVl1fVwJWjFulbZLWcI6bJ+dc5IvgC8KaCELthjoiqtfXB6X/KyRg
IqCKOQZsYGI=
=NoZg
-----END PGP SIGNATURE-----

--=-dlM6ZRJ9yWnqkQkXfIiQ--

