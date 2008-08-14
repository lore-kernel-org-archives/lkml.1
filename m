Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYHNOqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYHNOqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYHNOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:45:59 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:63396 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbYHNOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:45:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAEXio0jCTsYx/2dsb2JhbACBYrRfgVU
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Date: Thu, 14 Aug 2008 16:45:52 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808141604.22287.laurentp@cse-semaphore.com> <20080814141428.GA32296@oksana.dev.rtsoft.ru>
In-Reply-To: <20080814141428.GA32296@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1427864.eYTl2Dx6rT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808141645.56418.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1427864.eYTl2Dx6rT
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 August 2008, Anton Vorontsov wrote:
> On Thu, Aug 14, 2008 at 04:04:18PM +0200, Laurent Pinchart wrote:
> > On Friday 08 August 2008, Anton Vorontsov wrote:
> > > We'll need this function to write platform-specific hooks to deal
> > > with pin's dedicated functions. Quite obviously this will work only
> > > for the platforms with 1-to-1 GPIO to PIN mapping.
> > >=20
> > > This is stopgap solution till we think out and implement a proper
> > > api (pinlib?).
> >=20
> > How do you support reverting the GPIO mode to non-dedicated ?
>=20
> As we always do with the GPIO API: gpio_direction_*() calls.

So the proper sequence to configure a pin in dedicated mode is to set the d=
irection first (which will unset the dedicated mode bit) and then set dedic=
ated mode (which will not touch the direction bit) ?

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1427864.eYTl2Dx6rT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkikRSQACgkQ8y9gWxC9vpfKrACgxwIOgShMPlS42X8wUSXenXh4
T0MAnAg8qU96gLqeiLaphE/gzQ+K7LqC
=r5Er
-----END PGP SIGNATURE-----

--nextPart1427864.eYTl2Dx6rT--
