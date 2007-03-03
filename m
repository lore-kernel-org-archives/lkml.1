Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbXCCUPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbXCCUPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXCCUPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:15:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:30194 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXCCUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:15:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pPehXrz/O0ODYr4PcGlqbtbj9nMr4PmrjQaB39P+gYTlyZj71GYKA6X7M06tMesworR30FK/kQY/tpVPQPVf7+GZ33MWS0u/VuabawuJ7S+efxY0cKOQ6eC6jGzAgSM7kuw1sdjwQqJoYDC8cwJf2yfSNAs5lmiCWVHE59163kY=
Date: Sat, 3 Mar 2007 21:15:41 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pata_jmicron: remove spurious #endif
Message-ID: <20070303201541.GA22621@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
commit 438ac6d5e3f8106a6bd1a5682c508d660294a85d causes a build failure:

  CC      drivers/ata/pata_jmicron.o
  /home/kronos/src/linux-2.6.git/drivers/ata/pata_jmicron.c:247:2: error: #endif without #if
  make[3]: *** [drivers/ata/pata_jmicron.o] Error 1

Remove a spurious #endif in pata_jmicron driver.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
---

 drivers/ata/pata_jmicron.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 033319e..43763c9 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -244,7 +244,6 @@ static void __exit jmicron_exit(void)
 {
 	pci_unregister_driver(&jmicron_pci_driver);
 }
-#endif
 
 module_init(jmicron_init);
 module_exit(jmicron_exit);


Luca
-- 
You and me baby ain't nothin' but mammals
So let's do it like they do on the Discovery Channel
