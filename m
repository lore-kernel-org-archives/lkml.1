Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbXLNMQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbXLNMQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbXLNMQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:16:30 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:45487 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXLNMQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:16:28 -0500
X-Greylist: delayed 7877 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 07:16:28 EST
Subject: Re: [argyllcms] Re: [PATCH] usb/hid: Blacklist the Gretag-Macbeth
	Huey display	colorimeter
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: argyllcms@freelists.org
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Frederic Crozat <fcrozat@mandriva.com>,
       Greg KH <greg@kroah.com>, jkosina@suse.cz
In-Reply-To: <47626D00.202@argyllcms.com>
References: <1197585460.28927.2.camel@rousalka.dyndns.org>
	 <20071214053853.GD7765@kroah.com>
	 <1197626696.5281.5.camel@rousalka.dyndns.org>  <47626D00.202@argyllcms.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JfrDzLvOQu3/NPs6qZ2C"
Organization: Perso
Date: Fri, 14 Dec 2007 13:16:19 +0100
Message-Id: <1197634579.2766.8.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.3 (2.21.3-4.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JfrDzLvOQu3/NPs6qZ2C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Le vendredi 14 d=C3=A9cembre 2007 =C3=A0 22:46 +1100, Graeme Gill a =C3=A9c=
rit :
> Nicolas Mailhot wrote:
>=20
> >>Care to make up a patch as per the Documentation/SubmittingPatches file
> >>and send it to this list and the HID driver maintainer?  That way you
> >>get the proper credit for this change.
> >=20
> > The things I do as a public service, I don't even have the damn Huey
> > myself:(
>=20
> Actually (to put it frankly), I'm amazed that this exceptions list is
> compiled into the driver. I would have thought that such a list should
> at least be in a configuration file that an installed application can
> add or delete, if not something more sophisticated.

Something more sophisticated will happen someday, this is what we have
now.

> What will happen if the
> HID driver is fixed to allow arbitrary messages, and I want to switch
> back to using it rather than libusb ?

Then the person doing the HID code fix should remove the blacklist entry
at the same time.

> And the question still remains as to why usb_detach_kernel_driver_np()
> works fine on some systems (ie. the one I'm testing on), and not (apparen=
tly)
> others.

I'm not saying it does not work, I'm saying I don't want my users to
fool with kernel modules when we know the default should not be HID for
huey right now. If you prefer enhancing the kernel HID driver, and
switching argyll to it, just do it. I don't care as long as I don't have
to maintain workarounds distro-side.

--=20
Nicolas Mailhot

--=-JfrDzLvOQu3/NPs6qZ2C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkdidAwACgkQI2bVKDsp8g0+tACgyXmUHpObepwDAuuDcsd4auOA
3KgAoLGIOJnXGmMl8MhFMdZw7WEaxa9F
=AvWT
-----END PGP SIGNATURE-----

--=-JfrDzLvOQu3/NPs6qZ2C--

