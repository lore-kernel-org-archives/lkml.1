Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXDQJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXDQJ6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXDQJ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:58:40 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:39949 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753205AbXDQJ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:58:39 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: tony.olech@elandigitalsystems.com
Subject: [PATCH] Remove duplicate define of OHCI_QUIRK_ZFMICRO
Date: Tue, 17 Apr 2007 12:56:28 +0300
User-Agent: KMail/1.9.6
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200704171256.31516.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate define of OHCI_QUIRK_ZFMICRO from ftdi-elan.c, its already 
defined in drivers/ush/host/ohci.c

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index bc3327e..a283816 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2304,7 +2304,6 @@ static int ftdi_elan_checkingPCI(struct usb_ftdi *ftdi)
 #define OHCI_QUIRK_SUPERIO 0x02
 #define OHCI_QUIRK_INITRESET 0x04
 #define OHCI_BIG_ENDIAN 0x08
-#define OHCI_QUIRK_ZFMICRO 0x10
 #define OHCI_CONTROL_INIT OHCI_CTRL_CBSR
 #define OHCI_INTR_INIT (OHCI_INTR_MIE | OHCI_INTR_UE | OHCI_INTR_RD | \
         OHCI_INTR_WDH)

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
