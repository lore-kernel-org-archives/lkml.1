Return-Path: <linux-kernel-owner+w=401wt.eu-S1946572AbXBIPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946572AbXBIPfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXBIPfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946572AbXBIPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=epaCiDyhT9Uj/2b6k8wQyM+GO8hvqL8YCp4T83r3C/VXTia5vb2EWdk9x/DHDwZLMcNRIv+/4xXCddoipXJlV2ddq8/qY3QEHiphu0h7P6gz3cg/EECBl/JTFkqxnU4qTSg6qub1E6pIFk91HjxypPytzHaA8cim7+DU2SkBjuw=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, James.Bottomley@steeleye.com
Subject: [PATCH 32/34] __initdata cleanup - scsi
Date: Fri, 9 Feb 2007 17:34:35 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091734.35346.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/scsi/aha1542.c linux-2.6.20-rc6-mm3/drivers/scsi/aha1542.c
--- linux-2.6.20-rc6-mm3.org/drivers/scsi/aha1542.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aha1542.c	2007-01-31 22:19:30.000000000 +0200
@@ -943,7 +943,7 @@ fail:
 }
 
 #ifndef MODULE
-static char *setup_str[MAXBOARDS] __initdata;
+static char *setup_str[MAXBOARDS] __initdata = {0};
 static int setup_idx = 0;
 
 static void __init aha1542_setup(char *str, int *ints)
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/scsi/pluto.c linux-2.6.20-rc6-mm3/drivers/scsi/pluto.c
--- linux-2.6.20-rc6-mm3.org/drivers/scsi/pluto.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/scsi/pluto.c	2007-01-31 22:19:30.000000000 +0200
@@ -47,7 +47,7 @@ static struct ctrl_inquiry {
 	Scsi_Cmnd cmd;
 	char inquiry[256];
 	fc_channel *fc;
-} *fcs __initdata;
+} *fcs __initdata = NULL;
 static int fcscount __initdata = 0;
 static atomic_t fcss __initdata = ATOMIC_INIT(0);
 DECLARE_MUTEX_LOCKED(fc_sem);
