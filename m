Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbZLKLd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbZLKLd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbZLKLdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:33:03 -0500
Received: from smtp.nokia.com ([192.100.122.233]:50320 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762405AbZLKLc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:32:26 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 4/5] usb: musb: isp1704: add registers from isp1704
Date: Fri, 11 Dec 2009 13:31:25 +0200
Message-Id: <1260531086-23857-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
X-OriginalArrivalTime: 11 Dec 2009 11:31:53.0108 (UTC) FILETIME=[897ED540:01CA7A55]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transceiver used on RX-51 board.

NYET-Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/musb/isp1704.h |   81 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/musb/isp1704.h

diff --git a/drivers/usb/musb/isp1704.h b/drivers/usb/musb/isp1704.h
new file mode 100644
index 0000000..c52406e
--- /dev/null
+++ b/drivers/usb/musb/isp1704.h
@@ -0,0 +1,81 @@
+/*
+ * isp1704.h - ISP 1704 Register
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ * NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef __ISP1704_H__
+#define __ISP1704_H__
+
+#define ISP1704_VENDOR_ID_LOW		0x00
+#define ISP1704_VENDOR_ID_HIGH		0x01
+#define ISP1704_PRODUCT_ID_LOW		0x02
+#define ISP1704_PRODUCT_ID_HIGH		0x03
+#define ISP1704_FUNC_CTRL		0x04
+#define ISP1704_OTG_CTRL		0x0a
+#define ISP1704_USB_INTRISE		0x0d
+#define ISP1704_USB_INTFALL		0x10
+#define ISP1704_DEBUG			0x15
+#define ISP1704_SCRATCH			0x16
+#define ISP1704_PWR_CTRL		0x3d
+
+/* Function control */
+#define ISP1704_FUNC_CTRL_FULL_SPEED	(1 << 0)
+#define ISP1704_FUNC_CTRL_XCVRSELECT	0x3
+#define ISP1704_FUNC_CTRL_XCVRSELECT_SHIFT	(1 << 0)
+#define ISP1704_FUNC_CTRL_TERMSELECT	(1 << 2)
+#define ISP1704_FUNC_CTRL_OPMODE	(1 << 3)
+#define ISP1704_FUNC_CTRL_OPMODE_SHIFT	3
+#define ISP1704_FUNC_CTRL_RESET		(1 << 5)
+#define ISP1704_FUNC_CTRL_SUSPENDM	(1 << 6)
+
+/* OTG Control */
+#define ISP1704_OTG_CTRL_IDPULLUP	(1 << 0)
+#define ISP1704_OTG_CTRL_DP_PULLDOWN	(1 << 1)
+#define ISP1704_OTG_CTRL_DM_PULLDOWN	(1 << 2)
+#define ISP1704_OTG_CTRL_DISCHRG_VBUS	(1 << 3)
+#define ISP1704_OTG_CTRL_CHRG_VBUS	(1 << 4)
+#define ISP1704_OTG_CTRL_DRV_VBUS_EXT	(1 << 6)
+#define ISP1704_OTG_CTRL_USB_EXT_VBUS	(1 << 7)
+
+/* Debug */
+#define ISP1704_DEBUG_LINESTATE0	(1 << 0)
+#define ISP1704_DEBUG_LINESTATE1	(1 << 1)
+
+/* Power control */
+#define ISP1704_PWR_CTRL_SWCTRL		(1 << 0)
+#define ISP1704_PWR_CTRL_DET_COMP	(1 << 1)
+#define ISP1704_PWR_CTRL_BVALID_RISE	(1 << 2)
+#define ISP1704_PWR_CTRL_BVALID_FALL	(1 << 3)
+#define ISP1704_PWR_CTRL_DP_WKPU_EN	(1 << 4)
+#define ISP1704_PWR_CTRL_VDAT_DET	(1 << 5)
+#define ISP1704_PWR_CTRL_DPVSRC_EN	(1 << 6)
+#define ISP1704_PWR_CTRL_HWDETECT	(1 << 7)
+
+#endif	/* __ISP1704_H__ */
-- 
1.6.6.rc0

