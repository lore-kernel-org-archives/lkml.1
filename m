Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZBBWnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZBBWnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbZBBWnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:43:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43665 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348AbZBBWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=apdMnkFQkI/+j1Ue5A4MrTUlQszWo4xyZK9KI1Qvo79HNhmrgiONln19+sEoAY4npm
         cvFcq+ZkWAazTR6uYqZU2J4yHwqvm8ZsWpHOcGlghY3sZzUWu7uxtAwk623rewhWRcS6
         KKP8u2ur+lpRIVRkMVblyphk2ZgB9a5NhDGPc=
Date: Mon, 2 Feb 2009 23:42:49 +0100
From: Max Weninger <max.weninger@gmail.com>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, lifebook@conan.de
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not
 working
Message-ID: <20090202234249.2eca8c7c@zork.foo.com>
In-Reply-To: <4986F78D.5000901@wincor-nixdorf.com>
References: <20090125234902.7605fd16@zork.foo.com>
	<497D9469.3030908@wincor-nixdorf.com>
	<20090126124941.4f67aaf5@shire2>
	<497DA8E3.5070006@wincor-nixdorf.com>
	<20090127013806.5e31199f@zork.foo.com>
	<20090127014822.780ecb90@zork.foo.com>
	<20090127020529.4070840b@zork.foo.com>
	<20090130151836.891f3204.akpm@linux-foundation.org>
	<4986F78D.5000901@wincor-nixdorf.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//Fm0tPg0J2wBqXWFK9smIs8";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//Fm0tPg0J2wBqXWFK9smIs8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On Mon, 02 Feb 2009 14:39:25 +0100
Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:

> Andrew Morton wrote:
> > (cc restored - please jsut do reply-to-all, always)
> >=20
> > On Tue, 27 Jan 2009 02:05:29 +0100
> > Max Weninger <max.weninger@gmail.com> wrote:
> >=20
> >> Hi again
> >>
> >> On Tue, 27 Jan 2009 01:48:22 +0100
> >> Max Weninger <max.weninger@gmail.com> wrote:
> >>
> >>> On Tue, 27 Jan 2009 01:38:06 +0100
> >>> Max Weninger <max.weninger@gmail.com> wrote:
> >>>
> >>>> Hi
> >>>>
> >>>> On Mon, 26 Jan 2009 13:13:23 +0100
> >>>> Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> >>>>
> >>>>> Max Weninger wrote:
> >>>>>> Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> >>>>>>> You can obviously download the drivers from
> >>>>>>> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
> >>>>>>>
> >>>>>>> It would be great if eGalax could be convinced to get these
> >>>>>>> drivers included in main-line ;)
> >>>>>> Thanks for your quick reply
> >>>>>> BUT: I have tried those driver also
> >>>>>>
> >>>>>> I tried this "brandnew" one (but also older ones)
> >>>>>> http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416=
/TouchKit-2.06.2410-32b-k26.tar.gz
> >>>>>> after making it compile for 2.6.28.2 :)
> >>>>>> since there is source code delivered
> >>>>> For what it's worth; the version we use from eGalax is
> >>>>> 1.0.3.1701. I don't have the hardware here atm, so I can't test
> >>>>> an other driver now.
> >>>> I tried kernel 2.6.23.17 and there the touchscreen is recognized
> >>>> using the builtin usbtouchscreen driver
> >>> It also works with 2.6.26.8
> >> After comparing the usbtouchscreen.c sources between the different
> >> versions I got it working by commenting the follwoing lines
> >>
> >> ...
> >> #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> >>         /* ignore the HID capable devices, handled by usbhid */
> >>         {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =3D
> >> DEVTYPE_IGNORE}, {USB_DEVICE_HID_CLASS(0x0eef,
> >> 0x0002), .driver_info =3D DEVTYPE_IGNORE}, ...
> >>
> >> Now the entry in /proc/bus/input/devices is created as in the
> >> older versions.
> >>
> >> So it seems that usbhid is not correctly handling my type
> >> of touchscreen if I understand the comment there correctly
> >>
> >=20
> > So... how do we fix this for real?
>=20
> (...after some research...)
>=20
> Best would probably be updating the Xorg evtouch-driver. It looks
> like someone already did this. I found a site containing a quite
> complete description of (hopefully the same) problem:
> http://zalman.ostergaard.net/touch.html

Well the problem here IMHO is the following sentence found there
=20
> If you read something else from your touchscreen, you may as well skip
> reading further :-(

without the changes in usbtouchscreen /proc/bus/input/devices does
NOT contain any entry for my touchscreen.

> However I don't think the changes were submitted upstream as the
> (new) driver does not contain support for the other eGalax-hardware
> anymore.
>=20
> In my view the problem is not the Linux usbtouchscreen/usbhid driver,
> but the evtouch-driver. It looks like the evtouch-driver is not
> maintained by the Xorg-folks, but on
> http://www.conan.de/touchscreen/evtouch.html (contact added in CC).

I think the problem cannot be fixed by any changes on the X-level
since this requires that the underlying device is present
e.g. any /dev/input/event[x] device for the touchscreen

evtouch is just one level above and is just using the device
that is provided from the kernel aka. usbtouchscreen or usbhid

At least this is how I understand the architecture :)

Regards

max

--Sig_//Fm0tPg0J2wBqXWFK9smIs8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmHduwACgkQWFKBZOdSyBUH7gCdE0tQXa1gwghJyS9jhpbBH8JZ
7L4An3m8awpKi80tyb4ARNPJBqwaLO3D
=ILLi
-----END PGP SIGNATURE-----

--Sig_//Fm0tPg0J2wBqXWFK9smIs8--
