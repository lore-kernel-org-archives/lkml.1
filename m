Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXCBQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXCBQDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992554AbXCBQDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:03:31 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54443 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992551AbXCBQDa (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:03:30 -0500
Message-Id: <200703021603.l22G37Sa022890@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1 - fb_ddc_read() not defined
In-Reply-To: Your message of "Fri, 02 Mar 2007 03:00:26 PST."
             <20070302030026.5eef0c92.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1172851387_4365P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Mar 2007 11:03:07 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1172851387_4365P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Mar 2007 03:00:26 PST, Andrew Morton said:

>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/

> nvidiafb-bring-back-generic-ddc-reading.patch

Building with FB_DDC=N results in:

Kernel: arch/x86_64/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 229 modules
WARNING: "fb_ddc_read" [drivers/video/nvidia/nvidiafb.ko] undefined!
make[1]: *** [__modpost] Error 1

makes-it-build patch (not sure if it should be "select FB_DDC if MUMBLE"):

--- linux-2.6.21-rc2-mm1/drivers/video/Kconfig.nvidia	2007-03-02 09:27:48.000000000 -0500
+++ linux-2.6.21-rc2-mm1/drivers/video/Kconfig	2007-03-02 10:56:54.000000000 -0500
@@ -710,6 +710,7 @@ config FB_NVIDIA
 	select I2C_ALGOBIT if FB_NVIDIA_I2C
 	select I2C if FB_NVIDIA_I2C
 	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
+	select FB_DDC
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA



--==_Exmh_1172851387_4365P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF6Eq7cC3lWbTT17ARAtbUAJ49H3TbwnjPzFp2/C/zbYVnIGKyWgCfRyNm
4NKTdNUrx2Kv3jR8vCbWfis=
=9nnj
-----END PGP SIGNATURE-----

--==_Exmh_1172851387_4365P--
