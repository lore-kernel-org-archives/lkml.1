Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXCCPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXCCPjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030637AbXCCPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:39:20 -0500
Received: from havoc.gtf.org ([69.61.125.42]:36825 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030434AbXCCPjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:39:19 -0500
Date: Sat, 3 Mar 2007 10:39:17 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata build fix
Message-ID: <20070303153917.GA8938@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A merge mistake slipped upstream.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_jmicron.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

Jeff Garzik (1):
      [libata] pata_jmicron: build fix

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
