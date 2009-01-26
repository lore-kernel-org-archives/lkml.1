Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZAZLuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZAZLuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZAZLuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:50:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:40808 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZAZLt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=rDpcGUdOvr5t2nUx3Wqo0z8ETrmFgxEl02rcm6mHSYyjvvA9mxwEQFYfHOWlvDSJnG
         dJGwKY3NHfodiIlp7PF03KFSHXqf+gys6AV9e/yXiFvkyLm5nA607tYjOtDtm0SAB7gG
         iyhgrTW8dh+1BYjzclIbCKZLtJ/IpBrekh0zc=
Date: Mon, 26 Jan 2009 12:49:41 +0100
From: Max Weninger <max.weninger@gmail.com>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: support of touchscreen reported as eGalax but is not working
Message-ID: <20090126124941.4f67aaf5@shire2>
In-Reply-To: <497D9469.3030908@wincor-nixdorf.com>
References: <20090125234902.7605fd16@zork.foo.com>
	<497D9469.3030908@wincor-nixdorf.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/E3ElqdvlAuwO2jA=5g+P+Yn";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E3ElqdvlAuwO2jA=5g+P+Yn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On Mon, 26 Jan 2009 11:46:01 +0100
Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:

> Max Weninger wrote:
> > Hi
> >=20
> > I recently got a used USB touchscreen and try to get it working
> > It looks like a eGalax type but not really is :-(
> >=20
> ...
> > /proc/bus/usb/devices gives
> >=20
> > T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D 13 Spd=3D1.5=
 MxCh=3D 0
> > D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
> > P:  Vendor=3D0eef ProdID=3D0001 Rev=3D 1.00
> > C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 44mA
> > I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driv=
er=3Dusbhid
> > E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D5ms
> >=20
> > I compared this output to other eGalax and discovered some differences
> > like that iManufactur and iProduct is not filled also
> > bInterfaceSubClass and bInterfaceProtocol
>=20
> Looks like a touchscreen which is supported by a closed(?) source driver
> of eGalax we have here too:
> $ /sbin/modinfo tkusb.ko=20
> filename:       tkusb.ko
> license:        GPL
> description:    USB TouchScreen Driver
> author:         eGalax Inc. http://www.egalax.com.tw
> srcversion:     B0872D8913B07BF5665B5BA
> alias:          usb:v3823p0001d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0EEFp0002d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0EEFp0001d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1234p0002d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1234p0001d*dc*dsc*dp*ic*isc*ip*
> depends:        usbcore
> vermagic:       2.6.17-8.wn mod_unload 686 REGPARM 4KSTACKS gcc-4.0
>=20
> You can obviously download the drivers from
> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
>=20
> It would be great if eGalax could be convinced to get these drivers
> included in main-line ;)

Thanks for your quick reply
BUT: I have tried those driver also

I tried this "brandnew" one (but also older ones)
http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416/TouchKit=
-2.06.2410-32b-k26.tar.gz
after making it compile for 2.6.28.2 :)
since there is source code delivered

If I didnt make any error I get exactly the same error
maybe I did some error in the configuration but
it loads the tkusb kernel module instead of the usbtoucscreen
(which I added to the module blacklist) when plugin the screen
so I think I did it right :)

So maybe the problem is that the kernel is just too new=20
and some other changes broke the support :)
So I will try with the kernel you are using
(2.6.17-8) to make sure

Regards

max



--=20
_______________________________________________________________
     \                 =20
    o/\_          DI Max Weninger
   <\__,\         Email (max.weninger@gmail.com)         =20
    ">.  |        =20
     ` .-|       =20
        . \      =20
         . \     =20
         .-|     =20
_________._|____________________________________________________

--Sig_/E3ElqdvlAuwO2jA=5g+P+Yn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJfaNYWFKBZOdSyBURAjMgAKCut8RZpvviEaSgB2YKkFmApK5kMgCgsYqb
ZUFj49pBbEcf/l4a1NPYsF8=
=RJ63
-----END PGP SIGNATURE-----

--Sig_/E3ElqdvlAuwO2jA=5g+P+Yn--
