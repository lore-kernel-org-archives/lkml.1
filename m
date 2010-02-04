Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0BDR6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:58:18 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:35663 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab0BDR6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:58:15 -0500
Date: Thu, 4 Feb 2010 15:53:45 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: don@syst.com.br, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: use multi input quirk for TouchPack touchscreen
Message-ID: <20100204175345.GL1445@holoscopio.com>
References: <1265297785-1906-1-git-send-email-cascardo@holoscopio.com>
 <alpine.LNX.2.00.1002041845350.15395@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/+CTqSGWdiRg+8j"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1002041845350.15395@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/+CTqSGWdiRg+8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 04, 2010 at 06:46:26PM +0100, Jiri Kosina wrote:
> On Thu, 4 Feb 2010, Thadeu Lima de Souza Cascardo wrote:
>=20
> > This device generates ABS_Z and ABS_RX events, while it should be
> > generating ABS_X and ABS_Y instead. Using the MULTI_INPUT quirk solves
> > this issue.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Signed-off-by: Daniel Oliveira Nascimento <don@syst.com.br>
> > ---
> >  drivers/hid/hid-ids.h           |    3 +++
> >  drivers/hid/usbhid/hid-quirks.c |    1 +
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> > index e99485f..ba39103 100644
> > --- a/drivers/hid/hid-ids.h
> > +++ b/drivers/hid/hid-ids.h
> > @@ -398,6 +398,9 @@
> > =20
> >  #define USB_VENDOR_ID_THRUSTMASTER	0x044f
> > =20
> > +#define USB_VENDOR_ID_TOUCHPACK		0x1bfd
> > +#define USB_DEVIDE_ID_TOUCHPAK_RTS	0x1688
> > +
>=20
> Umm .. there are two typos in this single line. Please compile-test your=
=20
> patches before submitting them.
>=20
> I have fixed it and applied, thanks.
>=20

Heh! Daniel has pointed this out to me too. I'm pretty sure I've
finished this build, but something must have happened. Perhaps, this was
when my computer has turned off because of bad wiring and I forgot
completely that this was building.

I am sorry for this. And thanks for the fix.

> >  #define USB_VENDOR_ID_TOPMAX		0x0663
> >  #define USB_DEVICE_ID_TOPMAX_COBRAPAD	0x0103
> > =20
> > diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-q=
uirks.c
> > index edc598d..b89717d 100644
> > --- a/drivers/hid/usbhid/hid-quirks.c
> > +++ b/drivers/hid/usbhid/hid-quirks.c
> > @@ -45,6 +45,7 @@ static const struct hid_blacklist {
> >  	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MUL=
TI_INPUT },
> >  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYST=
ICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
> >  	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_Q=
UIRK_MULTI_INPUT },
> > +	{ USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS, HID_QUIRK_MUL=
TI_INPUT },
> > =20
> >  	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM, HID_QUIRK_NOGET },
> >  	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS124U, HID_QUIRK_NOGET },
> > --=20
> > 1.6.6.1
> >=20
>=20
> --=20
> Jiri Kosina
> SUSE Labs, Novell Inc.

--W/+CTqSGWdiRg+8j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktrCakACgkQyTpryRcqtS3IqwCgi4DfYj4ZMNVd2JlhnxwD+ujz
6/EAnRrM/N4c90YCshQ4Y4NRTPQ7emZk
=a3xC
-----END PGP SIGNATURE-----

--W/+CTqSGWdiRg+8j--
