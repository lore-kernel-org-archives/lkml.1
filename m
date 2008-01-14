Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbYANPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbYANPHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYANPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:07:28 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:46341 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbYANPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:07:27 -0500
Message-ID: <478B7A86.7010207@pengutronix.de>
Date: Mon, 14 Jan 2008 16:06:46 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: pengutronix
User-Agent: Icedove 1.5.0.14pre (X11/20071025)
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>, Dmitry Torokhov <dtor@mail.ru>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com> <478B31B6.3050406@pengutronix.de> <20080114144250.GA7443@rakim.wolfsonmicro.main>
In-Reply-To: <20080114144250.GA7443@rakim.wolfsonmicro.main>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF29A3972656F1D70799EB13"
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode
 on PXA2xx systems
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF29A3972656F1D70799EB13
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mark Brown wrote:
> On Mon, Jan 14, 2008 at 10:56:06AM +0100, Marc Kleine-Budde wrote:
>> reMark Brown wrote:
>=20
>>> Cc: Marc Kleine-Budde <mkl@penugtronix.de>
>>                                 ^^
>> it's mkl@pengutronix.de
>=20
> Fixed, sorry about that.
>=20
>>> +			/* use PEN_DOWN GPIO 13 to assert IRQ on GPIO line 2 */
>>> +			wm->pen_irq =3D MAINSTONE_AC97_IRQ;
>=20
>> I'm missing some kind of abstraction here, what about non mainstone
>> boards with the pen irq wired to some other gpio?
>=20
> The driver really isn't intended to cope with them.  As you say, other
> boards may have things wired up differently and therefore require
> different configuration of the wm97xx and other bits of the system.  Th=
e
> expectation is that other systems will have their own driver.

What bits have to setup in a different way? Only the stuff in
wm97xx_acc_startup() or other things aswell. An irq can be put as utual
into a device's resouce, Setting up bits may be done like other stuff on
pxa, too. e.g. pxa_set_ohci_info.

> My initial thought is that the most straightforward way of handling thi=
s
> would be to rename the driver to mainstone-wm97xx or similar to make it=

> clear that the driver is only intended to handle Mainstone as-is.  Does=

> that seem reasonable?

With my limited understanding of the pxa-wm97xx.c file, the only board
dependent stuff is done in wm97xx_acc_startup() so a different "driver"
for other boards would result in code duplication.

regards - Marc

--=20
 Marc Kleine-Budde              Phone: +49-231-2826-924
 Pengutronix - Linux Solutions for Science and Industry
 Vertretung West/Dortmund     http://www.pengutronix.de


--------------enigBF29A3972656F1D70799EB13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHi3qLjTAFq1RaXHMRApikAJ0Sn14UyJglVm/uKOQ+B3Smfbh8fwCfQxXo
kZml/x1VjD19jHWI9IMuECY=
=Y2kb
-----END PGP SIGNATURE-----

--------------enigBF29A3972656F1D70799EB13--
