Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0CCTKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:10:25 -0500
Received: from h1355771.stratoserver.net ([85.214.105.140]:35874 "EHLO
	h1355771.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0CCTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:10:17 -0500
X-Greylist: delayed 2291 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 14:10:17 EST
Date: Wed, 3 Mar 2010 19:31:56 +0100
From: Andreas Kemnade <andreas@kemnade.info>
To: Johan Hovold <jhovold@gmail.com>
Cc: peter@piie.net, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
Message-ID: <20100303193156.78127498@kemnade.info>
In-Reply-To: <20100303141718.GA15162@localhost>
References: <cone.1267466820.296261.3385.1000@deskpiie>
	<20100302235353.GB2196@kroah.com>
	<20100303114705.33716f9pnen8a8kc@webmail.df.eu>
	<20100303141718.GA15162@localhost>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Yh63hESCI0y0SgizQaittG2";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Yh63hESCI0y0SgizQaittG2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 3 Mar 2010 15:17:18 +0100
Johan Hovold <jhovold@gmail.com> wrote:

> On Wed, Mar 03, 2010 at 11:47:05AM +0100, peter@piie.net wrote:
> > Quoting Greg KH <greg@kroah.com>:
> > > On Mon, Mar 01, 2010 at 07:07:00PM +0100, Peter Feuerer wrote:
> > >> I connected two pls2302 usb-serial converters to two different
> > >> usb-ports of my machine and connected them with a rs232-nullmodem
> > >> cable to each other.
> > >>
> > >> Terminal1:
> > >> cat /dev/ttyUSB1
> > >>
> > >> Terminal2:
> > >> while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; =
done
> > >
> > > cat and echo are known to not work well with usb to serial devices.  =
Can
> > > you duplicate this with a "real" tty program like minicom or something
> > > else?
> >=20
> > I will try to set up a test use-case which uses kermit.
> >=20
> > But there is a calltrace in kernel log when using cat & echo, so =20
> > something in the driver went wrong.
> > Thus there is a bug which can be reproduced and it should be fixed, =20
> > don't you agree?
>=20
> Not necessarily. The warning you attached to your first post is a false
> one (it has been fixed in 2.6.33) and is not directly related to the
> problem you describe.
>=20
Are udev rules around which attach gpsd to the usb to serial adapter?
That might interfere.
I had problems with pl2302 adaptors due to that reason. I wondered why
stty -F /dev/ttyUSBx showed different things than on earlier calls.

Greetings
Andreas Kemnade

--Sig_/Yh63hESCI0y0SgizQaittG2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuOqxwACgkQvUy8S31NDea+fwCdHS8xD+BpJf8Ei41Sr/WTmt5c
btIAn0MC54GG7bqDnONpmpUXuTu3MXzx
=sejS
-----END PGP SIGNATURE-----

--Sig_/Yh63hESCI0y0SgizQaittG2--
