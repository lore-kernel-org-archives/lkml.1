Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXDBDa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXDBDa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 23:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXDBDa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 23:30:27 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:54743 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXDBDa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 23:30:26 -0400
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
From: Dan Engel <dan@sourceharvest.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
References: <1175396188.7857.15.camel@monica.engel.home>
	 <Pine.LNX.4.64.0704011057420.6040@jikos.suse.cz>
	 <200704011057.40725.dtor@insightbb.com>
	 <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4IxmMH9cX7ZCz8i6LcZY"
Date: Sun, 01 Apr 2007 23:28:59 -0400
Message-Id: <1175484539.12355.18.camel@monica.engel.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4IxmMH9cX7ZCz8i6LcZY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-04-01 at 19:43 +0200, Jiri Kosina wrote:
> On Sun, 1 Apr 2007, Dmitry Torokhov wrote:
>=20
> > No, I do not want to add any more LED constants to input. In fact I=20
> > think that adding constants beyond keyboard indicators was a mistake. W=
e=20
> > have led subsystem that provides interface to control arbitrary leds an=
d=20
> > we should use it.
>=20
> Ah, of course. Dan, could you please redo the patch to use the leds=20
> infrastructure and send it to me?

Perhaps I could find a way to do that, but it seem rather a round-about
way to go about it. The fact is that the input subsystem is already the
home of this device.

As far as I can tell, the led subsystem doesn't already provide any
framework for mapping LED's to HID input events. I could possibly create
a driver in the led subsystem that sends the corresponding events to the
input subsystem, but those events would be dropped by the input system,
anyway, since the event class would still have to be EV_LED and the code
would still be unrecognized without those two mappings.

Given that the HID or input subsystem still needs to be in the loop,
however the driver is written, can you give any advice for accomplishing
that without adding the extra LED mappings?

Thanks for any help,
-Dan Engel


--=-4IxmMH9cX7ZCz8i6LcZY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGEHh7eDYVehSTx+URAmTeAKCw40uuvaAwZk9t1ond59I8nX0xlgCdFgOn
sCgbIPejDbkRY/IGHu+Se6M=
=oCtq
-----END PGP SIGNATURE-----

--=-4IxmMH9cX7ZCz8i6LcZY--

