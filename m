Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZA0Aim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZA0Aim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZA0AiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:38:19 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:42217 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZA0AiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=KVAae+B70GiZq1BgNzcJKxzLk20ZXIZdE4qcJC60DGWHJMNMijbu09pXrlyjmt6uPh
         Oz8QRW7pJYcHvQtVNO2ip6JhMmfma4oixlH3ZV0CFWtCouWjfjEj6PD/D8Z0cnhox1WB
         iplwiymeo+kOByEPJN28G+4aquhlJurXUfVko=
Date: Tue, 27 Jan 2009 01:38:06 +0100
From: Max Weninger <max.weninger@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: support of touchscreen reported as eGalax but is not working
Message-ID: <20090127013806.5e31199f@zork.foo.com>
In-Reply-To: <497DA8E3.5070006@wincor-nixdorf.com>
References: <20090125234902.7605fd16@zork.foo.com>
	<497D9469.3030908@wincor-nixdorf.com>
	<20090126124941.4f67aaf5@shire2>
	<497DA8E3.5070006@wincor-nixdorf.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gdpyW2Qg7zJRQv5nqd9fyHC";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gdpyW2Qg7zJRQv5nqd9fyHC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On Mon, 26 Jan 2009 13:13:23 +0100
Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:

> Max Weninger wrote:
> > Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> >> You can obviously download the drivers from
> >> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
> >>
> >> It would be great if eGalax could be convinced to get these drivers
> >> included in main-line ;)
> >=20
> > Thanks for your quick reply
> > BUT: I have tried those driver also
> >=20
> > I tried this "brandnew" one (but also older ones)
> > http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416/Touc=
hKit-2.06.2410-32b-k26.tar.gz
> > after making it compile for 2.6.28.2 :)
> > since there is source code delivered
>=20
> For what it's worth; the version we use from eGalax is 1.0.3.1701. I
> don't have the hardware here atm, so I can't test an other driver
> now.

I tried kernel 2.6.23.17 and there the touchscreen is recognized
using the builtin usbtouchscreen driver

/proc/bus/usb/devices delivers
T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D01 Cnt=3D01 Dev#=3D  2 Spd=3D1.5 MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D0eef ProdID=3D0001 Rev=3D 1.00
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 44mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driver=
=3Dusbtouchscreen
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D5ms

and

/proc/bus/input/devices
I: Bus=3D0003 Vendor=3D0eef Product=3D0001 Version=3D0100
N: Name=3D"USB Touchscreen 0eef:0001"
P: Phys=3Dusb-0000:00:1d.0-2/input0
S: Sysfs=3D/class/input/input3
U: Uniq=3D
H: Handlers=3Dmouse2 event3=20
B: EV=3Db
B: KEY=3D400 0 0 0 0 0 0 0 0 0 0
B: ABS=3D3

I also tried to blacklist the usbhid with 2.6.28.2
then it display Driver=3Dusbtouchscreen in /proc/bus/usb/devices
but still no entry in /proc/bus/input/devices

Any ideas?

Regards

max

--Sig_/gdpyW2Qg7zJRQv5nqd9fyHC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkl+V3EACgkQWFKBZOdSyBVzVgCgj0vUvPoDfhQf1HfT88fn8DTC
QtgAoLil8JKcNAA9630bAB5x0HxNV4X4
=rxFj
-----END PGP SIGNATURE-----

--Sig_/gdpyW2Qg7zJRQv5nqd9fyHC--
