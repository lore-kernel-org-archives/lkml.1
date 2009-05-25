Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZEYMmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZEYMmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZEYMmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:42:11 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:44776 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZEYMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=RZTWi/YpggyNzBFJVuaXNIiv6b4ibdYRDo1sLeKGW6fqMPZfJ0rVfaqK3WDzZlNe3H
         ig0LIUzcPUAf+VRHLsZNGDc9B4fmo4vYc2oec2KOSamGiiREomj+QnF0A134AmBUt/f/
         A3vHdnzxrY3xBPdr4kUVXJ2hXdLv3t5So9JDQ=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200905251323.07845.IvDoorn@gmail.com>
References: <1243247687.5322.8.camel@varda>
	 <200905251323.07845.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Tar+kO1GraXSYPlLpSIw"
Date: Mon, 25 May 2009 14:42:06 +0200
Message-Id: <1243255326.6297.53.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tar+kO1GraXSYPlLpSIw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El lun, 25-05-2009 a las 13:23 +0200, Ivo van Doorn escribi=C3=B3:
> On Monday 25 May 2009, Alejandro Riveira Fern=C3=A1ndez wrote:
> > I reported it previously but i'm resending it as a regresion
> >=20
> > More info on the bugzilla
> >=20
> >  http://bugzilla.kernel.org/show_bug.cgi?id=3D13362
> >=20
> > I bisected it in the estable tree (it regresses too) and the revert
> > helps there but reverting the upstream commit in mainline does not help
> > to fix it completely...
>=20
> Bug 9273 -  rt2500pci: low TCP throughput
> 	http://bugzilla.kernel.org/show_bug.cgi?id=3D9273
>=20
> Bug 443203 -  Fedora rawhide + ralink =3D slow bit rate
> 	https://bugzilla.redhat.com/show_bug.cgi?id=3D443203
>=20
> [Hardy][Intrepid] Low bandwidth with rt2400 / rt2500 drivers
> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/190515
>=20
> I can't call this a regression, dozens people have reported the problems
> ranging from kernels 2.6.25 to 2.6.29. Perhaps in your case it worked sli=
ghtly
> better once, but that was not the case for all other users.
>=20
> Have you tried the "iwconfig wlan0 rate54M" workaround?

   Yep during various releases I used that workaround but once I
switched to minstrel rate choosing alg (that's the neme isn't it) the
problem gone away and i got allways a good connection for several
releases and many kernels tried; till this patch. If I revert this patch
the problem goes away completly and reliably (i'm using 2.6.29.4 with
the patch reveted) so something has clearly regressed for me.

 You can see my coments ( ariveira ) on rt2x00 forums regarding the
issues you mention (low speed that gets fixed forcing the rate) in the
long thread about rt2500pci low rate[1].
=20
 Checking the message i see that it was 2.6.27  when i began using
minstrel and got a rock solid connection in 2.6.27.x, 2.6.28.x and
2.6.29 minus 64e1b00c974ddeae6a60ebb02e1c487371905cea

 The problem is not that I get a low rate on connect (1Mbit) that i can
easily fix with iwconfig the problem is that with 54M (and 48M and the
like) connections I get a bumpy and low speed connection.
=20
So I honesty think it is not the same issue and I hope you read this as
an interesting data point and not just as a duplicate.

Would the output of this script[2] for 2.6.29.4 with and without the
revert help you ?

>=20
> Ivo

Thanks for the response

[1]
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=3D5&t=3D4579&start=3D4=
5

[2] http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=3D5&t=3D4660=20

--=-Tar+kO1GraXSYPlLpSIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKGpIZAAoJEDO4iEReSTB2uOIQAJS9jIQd3a0T4OzZzF1m7QeY
ec3Rdgv3w/bJt7fKiOmq7VPdEyzqFwl4vVKLSdQPE5Um6bwTUMOKf5DWaKSS3zeY
nI09ynVi9e453C5Fe4rRoVFh1Fr6VuUhWZR5uQEadywSoi565qF5/kEjFfissvqS
KzLTfUj/icX8MaJSPR0MnosLBE9jC+rIRrZ3vTMjdR/6itDcU49iGTy66Yjehv95
4mLTua9TeBostrk5/XoMEy88S2W6xXb6ZigVKS5D9UBYgh3k4ttqbpfIP/C6DUCM
ja+z9qtTw3I/oqy7Osp4CjZzOborXLRSp7gXSZrHN4ln5olRA0ylldcii6fIyr9z
1VnN7W2V9eVb07PvJx7aHKcMoLHstM7Jd+iYWT/+4zUPdpD72H+4TxSQu5tdGC+R
dvtsgrUdfRNBmdve7SYjlilM1yyLosouDt/e+LqobzOCStYL7aBkCStf9pf7pBWP
wRukC415EorT5BhVfSvzK7tX2/0RTnwM0+axNLBZVAY//w1ewRp3A+hlC00YbaSg
DtPsFEgyoB/ZJ+ndqMvPIMxXnn8fufpWzyDOv/JC8Y6bJxZxtbvQp7RM0S1PQOfH
chutqFwZfRgrdvFmgah2oaCByoVKh2wiiLDYrzuElo7g47FBsLK6hb+QEuGvPzsB
4i2B5PKn1tQnshqtgrPS
=eiLk
-----END PGP SIGNATURE-----

--=-Tar+kO1GraXSYPlLpSIw--

