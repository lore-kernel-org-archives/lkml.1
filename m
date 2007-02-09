Return-Path: <linux-kernel-owner+w=401wt.eu-S1946579AbXBIPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946579AbXBIPgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946569AbXBIPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946562AbXBIPfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YkczaZXvhJCB8Ok0rnP0Ff0+JSYyD9oGsQs1WH8tJBsdethS6kMSvzeAYaaQ+9SVmhJcKeGklPOJph6LWUkT4bcwZxH2gIylpssSUNMYxvNdTvNuM5DNn6r1mLy9LEJwC/GCt8Rw6uuAioQHRKv3jXrV0alY5AzlcgQ5AJr3Qxw=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, bzolnier@gmail.com
Subject: [PATCH 23/34] __initdata cleanup -  ide
Date: Fri, 9 Feb 2007 17:27:32 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091727.32477.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/ide/ide.c linux-2.6.20-rc6-mm3/drivers/ide/ide.c
--- linux-2.6.20-rc6-mm3.org/drivers/ide/ide.c	2007-01-31 22:15:39.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/ide/ide.c	2007-01-31 22:19:30.000000000 +0200
@@ -1483,27 +1483,27 @@ static int __init match_parm (char *s, c
 }
 
 #ifdef CONFIG_BLK_DEV_ALI14XX
-static int __initdata probe_ali14xx;
+static int __initdata probe_ali14xx = 0;
 extern int ali14xx_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_UMC8672
-static int __initdata probe_umc8672;
+static int __initdata probe_umc8672 = 0;
 extern int umc8672_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_DTC2278
-static int __initdata probe_dtc2278;
+static int __initdata probe_dtc2278 = 0;
 extern int dtc2278_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_HT6560B
-static int __initdata probe_ht6560b;
+static int __initdata probe_ht6560b = 0;
 extern int ht6560b_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_QD65XX
-static int __initdata probe_qd65xx;
+static int __initdata probe_qd65xx = 0;
 extern int qd65xx_init(void);
 #endif
 
-static int __initdata is_chipset_set[MAX_HWIFS];
+static int __initdata is_chipset_set[MAX_HWIFS] = {0};
 
 /*
  * ide_setup() gets called VERY EARLY during initialization,
