Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYLVAZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYLVAZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 19:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYLVAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 19:24:53 -0500
Received: from exch-gw.rose-hulman.edu ([137.112.8.200]:54708 "EHLO
	EXCH-GW.rose-hulman.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYLVAYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 19:24:52 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2008 19:24:52 EST
Date: Mon, 22 Dec 2008 00:09:38 +0000
From: Andy Spencer <spenceal@rose-hulman.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Paprocki <andrew@ishiboo.com>, LKML <linux-kernel@vger.kernel.org>,
       "dz@debian.org" <dz@debian.org>,
       Federico Heinz <fheinz@vialibre.org.ar>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS
	version with force=1
Message-ID: <20081222000938.GA25850@a.rose-hulman.edu>
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com> <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com> <20081221144109.2ed26cf2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20081221144109.2ed26cf2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Dec 2008 00:09:42.0079 (UTC) FILETIME=[9677F4F0:01C963C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2008 at 09:41:09AM -0500, Alan Cox wrote:
> I can find no copies of them with Signed-off-by: lines so they appear
> to have escaped. If the authors of those changes would care to
> provided Signed-off-by: lines I'll chase this up further.

Patch to enable i8k on Dell Precisions.

Signed-off-by: Andy Spencer <spenceal@rose-hulman.edu>

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index b60d425..099fc89 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -485,6 +485,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
 		},
 	},
+	{
+		.ident = "Dell Precision",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+		},
+	},
 	{ }
 };

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklO2sIACgkQz1OYJ/s1XTB9ZgCeJCnU0DNidonH1f2lW+K5FOQX
LCUAoJCbHf3mOL0x+9wHCLT3P4AbVIzI
=9jUl
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
