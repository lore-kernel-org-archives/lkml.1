Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZDTSVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZDTSVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZDTSVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:21:17 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:57325 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZDTSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:21:15 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 14:21:14 EDT
Message-ID: <49ECBAE2.2080308@dell.com>
Date: Mon, 20 Apr 2009 13:11:46 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Add support for Eject hotkey in dell-wmi
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC03E03A2E1CC52A978F4E278"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC03E03A2E1CC52A978F4E278
Content-Type: multipart/mixed;
 boundary="------------090107030500060303050807"

This is a multi-part message in MIME format.
--------------090107030500060303050807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

I've gotten word that future Dell consumer laptops are transitioning
several hotkeys to WMI instead.  Here's a patch to enable the first to
enable the Eject hotkey.  I'm attaching it since my mail server
(exchange) would mangle it otherwise.

Thanks,
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------090107030500060303050807
Content-Type: text/x-patch;
 name="dell-wmi-eject.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-eject.patch"

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-20 07:41:12.000000000 -050=
0
+++ b/drivers/platform/x86/dell-wmi.c	2009-04-20 07:42:04.000000000 -0500=

@@ -50,6 +50,7 @@
=20
 static struct key_entry dell_wmi_keymap[] =3D {
 	{KE_KEY, 0xe045, KEY_PROG1},
+	{KE_KEY, 0xe009, KEY_EJECTCD},
 	{KE_END, 0}
 };
=20

--------------090107030500060303050807--

--------------enigC03E03A2E1CC52A978F4E278
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknsuuIACgkQ2CrZjkA73Ys68wCgkfPAGhrzgnC46qSIZdfMtnzS
r18AniwOe4LrV1Bt4/W4jMe37nn5iXm6
=zAnW
-----END PGP SIGNATURE-----

--------------enigC03E03A2E1CC52A978F4E278--
