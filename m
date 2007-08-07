Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXHGKWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXHGKWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXHGKWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:22:03 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42827 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbXHGKWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:22:01 -0400
Date: Tue, 7 Aug 2007 19:21:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Enable hcd support on SH unconditionally.
Message-ID: <20070807102109.GB11186@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previous boards were likely seeing USB_ARCH_HAS_HCD selected by way
of PCMCIA or PCI, though none of those are required for hcd support
on SH. Enable support unconditionally.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/usb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 7dd7354..57a6648 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -18,6 +18,7 @@ config USB_ARCH_HAS_HCD
 	default y if USB_ARCH_HAS_EHCI
 	default y if PCMCIA && !M32R			# sl811_cs
 	default y if ARM				# SL-811
+	default y if SUPERH				# r8a66597-hcd
 	default PCI
 
 # many non-PCI SOC chips embed OHCI
