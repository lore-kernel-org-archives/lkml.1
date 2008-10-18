Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbYJRNqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbYJRNqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 09:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYJRNqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 09:46:39 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49401 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYJRNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 09:46:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: balance parenthesis in wlan-ng headers
Date: Sat, 18 Oct 2008 15:46:39 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181546.40153.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Balance parenthesis in HFA384x_CMD_QOS_GET macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -824,7 +824,7 @@ PD Record codes
 #define		HFA384x_CMD_MACPORT_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET(value))
 #define		HFA384x_CMD_ISRECL(value)		((UINT16)(HFA384x_CMD_AINFO_GET((UINT16)(value) & HFA384x_CMD_RECL)))
 #define		HFA384x_CMD_RECL_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET(value))
-#define		HFA384x_CMD_QOS_GET(value)		((UINT16((((UINT16)(value))&((UINT16)0x3000)) >> 12))
+#define		HFA384x_CMD_QOS_GET(value)		((UINT16)((((UINT16)(value))&((UINT16)0x3000)) >> 12))
 #define		HFA384x_CMD_QOS_SET(value)		((UINT16)((((UINT16)(value)) << 12) & 0x3000))
 #define		HFA384x_CMD_ISWRITE(value)		((UINT16)(HFA384x_CMD_AINFO_GET((UINT16)(value) & HFA384x_CMD_WRITE)))
 #define		HFA384x_CMD_WRITE_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET((UINT16)value))
