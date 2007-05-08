Return-Path: <linux-kernel-owner+w=401wt.eu-S934556AbXEHWNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbXEHWNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXEHWNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:13:40 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:44459 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753135AbXEHWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:13:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 18:13:38 EDT
X-YMail-OSG: Azxfz54VM1kUNd9tYxfvubh6ePWiMYUZcDIS0bJVTN0b7kHY1Ia7995NGEsMMBh7Cf7T2PrKEA--
Date: Tue, 8 May 2007 17:06:55 -0500
From: Peter Samuelson <peter@p12n.org>
To: Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org
Subject: [uPATCH] a logitech mouse ID
Message-ID: <20070508220655.GA3997@p12n.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Adds the ID to recognise my PS/2 TrackMan Marble.

This is purely cosmetic: this is standard 3-button, no wheel or other
such features, so it already _worked_ just fine.  This patch suppresses
a warning about the unknown model, and changes the printk from "Mouse"
to "TrackMan".

Signed-Off-By: Peter Samuelson <peter@p12n.org>

--- drivers/input/mouse/logips2pp.c
+++ drivers/input/mouse/logips2pp.c
@@ -220,6 +220,7 @@
 		{ 66,	PS2PP_KIND_MX,					/* MX3100 reciver */
 				PS2PP_WHEEL | PS2PP_SIDE_BTN | PS2PP_TASK_BTN |
 				PS2PP_EXTRA_BTN | PS2PP_NAV_BTN | PS2PP_HWHEEL },
+		{ 72,	PS2PP_KIND_TRACKMAN,	0 },			/* T-CH11: TrackMan Marble */
 		{ 73,	0,			PS2PP_SIDE_BTN },
 		{ 75,	PS2PP_KIND_WHEEL,	PS2PP_WHEEL },
 		{ 76,	PS2PP_KIND_WHEEL,	PS2PP_WHEEL },

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQPR/Xk7sIRPQRh0RAqL9AKDHHLHhT40nUSOTCbEtF+B6EoCaOwCeOaCf
338YhpOqeN5HntLtdy+gHxw=
=Xyey
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
