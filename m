Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZDLKsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZDLKsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760037AbZDLKrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:47:35 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49840 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513AbZDLKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:47:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 2/4] remove unbalanced opening brace from drivers/atm/iphase.c
Date: Sun, 12 Apr 2009 12:47:29 +0200
Message-Id: <1239533251-31276-3-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
References: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's under #ifdef 0 but I think it's worth fixing anyway.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
---
 drivers/atm/iphase.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 78c9736..dd8c3ec 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -795,7 +795,7 @@ static void ia_hw_type(IADEV *iadev) {
          iadev->rx_buf_sz, iadev->rx_pkt_ram);)
 
 #if 0
-   if ((memType & FE_MASK) == FE_SINGLE_MODE) {
+   if ((memType & FE_MASK) == FE_SINGLE_MODE)
       iadev->phy_type = PHY_OC3C_S;
    else if ((memType & FE_MASK) == FE_UTP_OPTION)
       iadev->phy_type = PHY_UTP155;
-- 
1.5.6.3

