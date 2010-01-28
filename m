Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0A1Kpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0A1Kpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0A1Kpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:45:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0A1Kps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:45:48 -0500
Date: Thu, 28 Jan 2010 11:45:45 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: John Williams <john.williams@petalogix.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Grant Likely <grant.likely@secretlab.ca>, magnus.damm@gmail.com,
       hjk@linutronix.de, gregkh@suse.de, linuxppc-dev@lists.ozlabs.org,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: UIO / of_genirq driver
Message-ID: <20100128104545.GA3105@pengutronix.de>
References: <1d3f23371001272313i62fc9158se4cd9173f196fb12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <1d3f23371001272313i62fc9158se4cd9173f196fb12@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

John,

> I came across this thread/patchset from around June last year:
>=20
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073086.html
>=20
> where Wolfgang proposed a generic OF-driven UIO driver.  The

Wolfram, please ;)

> discussion seemed to stall after Grant Likely indicated he didn't like
> the use of a linux-specific compatible binding in the device tree
> (compatible=3D"generic-uio").

I agree with him on that.

> I guess I have a couple of questions:
>=20
>  * did this patchset go anywhere?  I've been using it here the last
> few days and it works great.

The idea was to create a mechanism to instantiate bindings at runtime, simi=
lar
to new_id for PCI/PCMCIA, e.g.:

$ echo "commodore,c64" > /sys/bus/of_platform/drivers/of_uio_genirq/new_com=
patible

so we don't have to maintain an ever growing list of hardcoded
compatible-properties for those UIO-devices.

>  * Is there a better way to handle the OF bindings for this sort of thing?

Run-time instantiation might help in a couple of other cases; still, in the
progress of unifying/extending the OF-support, it was discussed if it was
possible to get rid of of_platform entirely. It looks like a very challengi=
ng
task, but seems to be favoured designwise (at least I do).

> However, the device-tree guys complain whenever anyone tries to encode
> anything non-hardware related into the DTS itself.

Well, if I get a device tree including special properties for Linux and BSD=
 and
whatever may follow, that could get quite confusing :)

> I guess I'd like to just open up a discussion, see if there's been any
> progress towards a general solution.

I decided to wait for the outcome of the of_platform-removal-idea. Though, I
have to admit that in the last weeks I haven't followed of-related things d=
ue
to other commitments.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkthatkACgkQD27XaX1/VRvjrACgketVU/GiUf+uHBeK1ACqDNbo
xpwAoMw9nB8eMvfqMgCwl8PXG1TqgmXk
=qPOC
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
