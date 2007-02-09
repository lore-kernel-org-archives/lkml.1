Return-Path: <linux-kernel-owner+w=401wt.eu-S1946563AbXBIPfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946563AbXBIPfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946569AbXBIPfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946567AbXBIPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hRf1p43OhDvpbqq7kOl2hyGJ7JZ0Ge5AA97cSEYxbUharnISZA7PAHyXQSVoLTSRZ7Uwc6S6D+lNzQm+ngSeqPOeJmOOMvBec71iRGy72FZNZu+65HBsr6ykI6ixEcOZpLWRCSas47/75WLe1X6rH9F3BUFDugU2//jRTRVyEGg=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, jgarzik@pobox.com
Subject: [PATCH 26/34] __initdata cleanup - intel-rng
Date: Fri, 9 Feb 2007 17:31:12 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091731.12209.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/char/hw_random/intel-rng.c linux-2.6.20-rc6-mm3/drivers/char/hw_random/intel-rng.c
--- linux-2.6.20-rc6-mm3.org/drivers/char/hw_random/intel-rng.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/char/hw_random/intel-rng.c	2007-01-31 22:19:30.000000000 +0200
@@ -143,7 +143,7 @@ static const struct pci_device_id pci_tb
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
-static __initdata int no_fwh_detect;
+static __initdata int no_fwh_detect = 0;
 module_param(no_fwh_detect, int, 0);
 MODULE_PARM_DESC(no_fwh_detect, "Skip FWH detection:\n"
                                 " positive value - skip if FWH space locked read-only\n"
@@ -219,7 +219,7 @@ static struct hwrng intel_rng = {
 
 
 #ifdef CONFIG_SMP
-static char __initdata waitflag;
+static char __initdata waitflag = 0;
 
 static void __init intel_init_wait(void *unused)
 {
