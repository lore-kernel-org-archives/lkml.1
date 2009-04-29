Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZD2SOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZD2SOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZD2SNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:13:54 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:50337 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZD2SNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:13:53 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49F898E4.5080605@dell.com>
Date: Wed, 29 Apr 2009 13:13:56 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore garbage in dell-wmi events
References: <49F73F92.9000201@dell.com> <20090429165517.GA32619@srcf.ucam.org>
In-Reply-To: <20090429165517.GA32619@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFEC75F7DC5669AF89D0F6CA7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEC75F7DC5669AF89D0F6CA7
Content-Type: multipart/mixed;
 boundary="------------090001070804050204040304"

This is a multi-part message in MIME format.
--------------090001070804050204040304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sure.  Do you want me to resend all of them to add that?

Matthew Garrett wrote:
> Hi Mario,
>
> Can you add your signed-off-by: for this?
>
> Thanks,
>  =20
Regards,

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------090001070804050204040304
Content-Type: text/x-patch;
 name="dell-wmi-mask-buffer.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-mask-buffer.patch"

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
---

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-28 12:32:32.000000000 -050=
0
+++ b/drivers/platform/x86/dell-wmi.c	2009-04-28 12:33:02.000000000 -0500=

@@ -182,7 +182,7 @@
=20
 	if (obj && obj->type =3D=3D ACPI_TYPE_BUFFER) {
 		int *buffer =3D (int *)obj->buffer.pointer;
-		key =3D dell_wmi_get_entry_by_scancode(buffer[1]);
+		key =3D dell_wmi_get_entry_by_scancode(0xFFFF & buffer[1]);
 		if (key) {
 			input_report_key(dell_wmi_input_dev, key->keycode, 1);
 			input_sync(dell_wmi_input_dev);
@@ -190,7 +190,7 @@
 			input_sync(dell_wmi_input_dev);
 		} else
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
-			       buffer[1]);
+			       0xFFFF & buffer[1]);
 	}
 }
=20

--------------090001070804050204040304--

--------------enigFEC75F7DC5669AF89D0F6CA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn4mOcACgkQ2CrZjkA73Yvb3gCggv3F41isy2mRjm1cYnmocY60
hDEAn1jm8bKtAXFlEfMlxr7GaTw9x1fn
=MlpP
-----END PGP SIGNATURE-----

--------------enigFEC75F7DC5669AF89D0F6CA7--
