Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbXIAGK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbXIAGK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXIAGKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:10:17 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3326 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXIAGKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:10:15 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH] skge: unbalanced parenthesis fix
Date: Sat, 1 Sep 2007 08:10:12 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709010810.12798.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes unbalanced parenthesis.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/skge.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1-a/drivers/net/skge.h	2007-09-01 07:23:52.000000000 +0200
+++ linux-2.6.23-rc4-mm1-b/drivers/net/skge.h	2007-09-01 07:37:55.000000000 +0200
@@ -1351,7 +1351,7 @@ enum {
 	PHY_M_PC_EN_DET_PLUS	= 3<<8, /* Energy Detect Plus (Mode 2) */
 };

-#define PHY_M_PC_MDI_XMODE(x)	((((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
+#define PHY_M_PC_MDI_XMODE(x)	(((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)

 enum {
 	PHY_M_PC_MAN_MDI	= 0, /* 00 = Manual MDI configuration */
