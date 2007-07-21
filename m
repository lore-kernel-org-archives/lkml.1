Return-Path: <linux-kernel-owner+w=401wt.eu-S939951AbXGUPGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939951AbXGUPGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939220AbXGUPDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939180AbXGUPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=e3WbU6wvDrVGYe7LQCAXOojOx9Pnl/p243b8ue0kFS/j0rfJtRahBDOW2lCcJlGBs1iSf3R6vFjWr+emvbyIck45jIe4+dYldMG54t3NhD3aLc2fw/VKVBnXISoGIuYmnUIaDWAiKfz3T0M/Dk8d/jcgJeb+WPNvmvW/texWUCY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][07/37] Clean up duplicate includes in drivers/hwmon/
Date: Sat, 21 Jul 2007 17:02:01 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>,
       Mark Hoffman <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.01755.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/hwmon/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/hwmon/ams/ams-core.c b/drivers/hwmon/ams/ams-core.c
index 6db9737..a112a03 100644
--- a/drivers/hwmon/ams/ams-core.c
+++ b/drivers/hwmon/ams/ams-core.c
@@ -23,7 +23,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/module.h>
 #include <asm/pmac_pfunc.h>
 #include <asm/of_platform.h>
 
