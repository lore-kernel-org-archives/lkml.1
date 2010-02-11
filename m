Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0BKXNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:13:37 -0500
Received: from nn7.de ([85.214.94.156]:39970 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab0BKXNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:13:36 -0500
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
From: Soeren Sonnenburg <sonne@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: nicolas@boichat.ch, felipe_alfaro@linuxmail.org,
       Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100211204441.GA5956@srcf.ucam.org>
References: <1265920725.7103.7.camel@no>
	 <20100211204441.GA5956@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CEggUslLzhAyqCSi0nLf"
Date: Fri, 12 Feb 2010 00:13:32 +0100
Message-ID: <1265930012.3485.1.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CEggUslLzhAyqCSi0nLf
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-11 at 20:44 +0000, Matthew Garrett wrote:
> On Thu, Feb 11, 2010 at 09:38:45PM +0100, Soeren Sonnenburg wrote:
> > Dear all,

Hi Matthew,

thanks for the quick answer.

> > I am booting a MacBookPro5,3 using elilo and efifb. Now I'd like to use
> > pommed to control display brightness (which won't work). Digging around
> > in mbp_nvidia_bl.c I figured out that tries to control the geforce 9600=
M
> > instead of the currently active geforece 9400m
>=20
> So, first of all, use nouveau instead. But moving on...

Unfortunately nouveau (from kernel 2.6.33-rc7) just hangs after loading
firmware and initialising fifo 1...

> > 02:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600=
M GT] (rev a1)
> > 03:00.0 VGA compatible controller: nVidia Corporation C79 [GeForce 9400=
M] (rev b1)
> >=20
> > Does anyone have an idea which bytes to tweak to change brightness
> > levels for the 9400? Seems like 0x52f does not work - at least
> > setpci -s 03:00.0 0x52f.B=3D10 fails...
>=20
> Those are mmio registers, not PCI config ones. You won't be able to=20
> change them with setpci.

I see...

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-CEggUslLzhAyqCSi0nLf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLdI8VAAoJEH82z1Wqh6p3NMYP/1/8kKsCuUiDkNPmW/Ox40RL
IbHYt8lTl+dB3OQ64tat5a+g5KhfdhmA3M7Qy76YvIybi7CJY7ytiCCOLWbQ/O0R
RkR9/mDIRFYTJDch/N/u0fvI/rXKeyFpb2LN6pXw0qybECMxN1L82C9u2y2kTmxm
T7HYnFXYWh/a82Oo1xKT5oO7+cdI9lhU+Rj4gLlfqxIDJqaeXlic/H98CpSW70FA
GFy2yn3oghLcfPbspFallzpWhO7DO8JXsYkqmKebvImprINSoQhMLn5dimx5Pkt1
Goi/d4JNkp6KVmQP+NScqbgDiQDsGbNNgqTKOWQEXjaJ0jWvHdinXekPBjJJe7Um
5L0d7VrLTY2MZfj8tHmjKdrr7pB86gURSMmfYv2PlbEMrpWou/aPbrtbSHf76unG
gOJKg6GFS7xq5fKiWlGF0f5Za4GvSezV02wOHj/VPVXd5pQrf5tWdK3T7P/BGUCC
XBciAu6FmgGWs5lZ/gAIHWipAbgUkOL8WJNSWDmP1sZQSJ6QKCtgbyVXwNs7c4Mm
QAbwXfAXVxPZlb9YKqYCSR7Wz5qaYd/Ot9TUbc3PABJ+XEYuF+dPL2I8cMdfDvis
B0ISLhdfbJ7kk6jv8HETgPWNDD1PHh+WRXDckVS2bq7d0LV/8298t1dxnOWYeJcF
mi/tqi7HQCMAJnH8W8L4
=Q2RI
-----END PGP SIGNATURE-----

--=-CEggUslLzhAyqCSi0nLf--
