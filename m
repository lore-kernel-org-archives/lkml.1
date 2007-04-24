Return-Path: <linux-kernel-owner+w=401wt.eu-S1423195AbXDXWpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423195AbXDXWpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423197AbXDXWpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:45:02 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42960 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423195AbXDXWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:45:00 -0400
Message-ID: <462E8869.2060804@simon.arlott.org.uk>
Date: Tue, 24 Apr 2007 23:44:57 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: trivial@kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: [PATCH] ohci1394: Fix mistake in printk message.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the "attempting to setting" message in ohci1394.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/ieee1394/ohci1394.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 628130a..107b272 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -618,7 +618,7 @@ static void ohci_initialize(struct ti_ohci *ohci)
 #endif
 
 		PRINT(KERN_DEBUG, "Serial EEPROM has suspicious values, "
-                      "attempting to setting max_packet_size to 512 bytes");
+                      "attempting to set max_packet_size to 512 bytes");
 		reg_write(ohci, OHCI1394_BusOptions,
 			  (reg_read(ohci, OHCI1394_BusOptions) & 0xf007) | 0x8002);
 		ohci->max_packet_size = 512;
-- 
1.5.0.1

-- 
Simon Arlott
