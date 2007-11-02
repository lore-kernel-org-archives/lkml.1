Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbXKBPqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbXKBPqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbXKBPok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:44:40 -0400
Received: from smtp-02.arnet.com.ar ([200.45.191.22]:39300 "HELO
	smtp-02.arnet.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760171AbXKBPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:38 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 11:44:37 EDT
Date: Fri, 2 Nov 2007 12:37:24 -0300
From: Federico Heinz <fheinz@vialibre.org.ar>
To: linux-kernel@vger.kernel.org
Subject: i8k for Dell Vostro (patch)
Message-ID: <20071102123724.736d523d@lauren.vialibre.org.ar>
Organization: =?UTF-8?B?RnVuZGFjacOzbiBWw61h?= Libre
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/27hmyc=1.3Fk97SQtceEe3=";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/27hmyc=1.3Fk97SQtceEe3=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This trivial patch adds support for i8k on the new Dell Vostro models.
I tested it on my Vostro 1400, and it works. It does print a warning
when loading the module:

	i8k: unable to get SMM BIOS version

But I couldn't figure out how to fix that. The module seems to work fine,
anyway...

	Fede

PS: I'm not subscribed to the list, please Cc me if you need me to read your
reply.

--- drivers/char/i8k.c.orig     2007-07-08 20:32:17.000000000 -0300
+++ drivers/char/i8k.c  2007-09-27 03:06:08.000000000 -0300
@@ -439,6 +439,13 @@
                        DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
                },
        },
+       {
+               .ident =3D "Dell Vostro",
+               .matches =3D {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
+               },
+       },
        { }
 };
=20

--Sig_/27hmyc=1.3Fk97SQtceEe3=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHK0Q1bPULDL0CxuARAtmlAJ9DS04/LDjWsAY9zmO4E70c2VLLhACgodaH
YnPK6IBQzcMfToEe7OLYsUo=
=4uJF
-----END PGP SIGNATURE-----

--Sig_/27hmyc=1.3Fk97SQtceEe3=--
