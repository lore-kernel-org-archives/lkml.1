Return-Path: <linux-kernel-owner+w=401wt.eu-S934586AbXGTH7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586AbXGTH7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbXGTH7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:59:12 -0400
Received: from wp050.webpack.hosteurope.de ([80.237.132.57]:59658 "EHLO
	wp050.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641AbXGTH7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:59:11 -0400
X-Greylist: delayed 1896 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 03:59:11 EDT
Date: Fri, 20 Jul 2007 09:27:30 +0200
From: Uwe Hermann <uwe@hermann-uwe.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070720072730.GN3700@greenwood>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <20070718204102.GM11115@waste.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <20070718204102.GM11115@waste.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-bounce-key: webpack.hosteurope.de;uwe@hermann-uwe.de;1184918351;a97aed78;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2007 at 03:41:02PM -0500, Matt Mackall wrote:
> On Wed, Jul 18, 2007 at 10:10:43PM +0200, Andi Kleen wrote:
> >=20
> > I was waiting for someone to make that "point" ...
> >=20
> > >=20
> > > Every byte you can shave off the compressed kernel image is another
> > > byte you can use for userspace on your FLASH.
> >=20
> > Now let's see if that 1MB 386 contains any flash at all. Guesses? =20
>=20
> I've certainly worked on such devices. I expect there are more of them
> still in service, than, say, Voyagers.
>=20
> I haven't looked at whether this CPUID stuff is worth the trouble, I'm
> just responding to your argument about init code. Init code is
> definitely not free. It takes up storage space, which can be extremely
> valuable.

Ack.

Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip) when
using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
there how big the kernel is. At the moment you can't do that with
anything smaller than a 1 MB chip. But if people could use 512 KB chips
because the kernel is small enough that would sure be a great thing.

In such scenarios every single byte matters.


Uwe.
--=20
http://www.hermann-uwe.de  | http://www.holsham-traders.de
http://www.crazy-hacks.org | http://www.unmaintained-free-software.org

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoGPiXdVoV3jWIbQRArMsAJ98ucQKZaEUXUuJRWna+5wR1pt2NgCeK81F
JmhbIBpANAzVozBTLMIgROk=
=Tsy5
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
