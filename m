Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZEIQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZEIQ7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZEIQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:59:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42103 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZEIQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i9rw8RItUSPJgf8xiIPVwJ/SI+aqkewwl5cMWoMR/RPteRsB8JmeDWdFf/WLpYuxta
         kHGGdS1gGRYVR63ki7/L0RGTbk/VRn0rbGhdLVBDw9EgWhhGsj+NFzcMV9O+MxlEkvsI
         C40bm7cqvhBcifeMNZkFMfJD6q3Iuh0D9FgpY=
From: Richard Genoud <richard.genoud@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] Remove duplicate slow protocol define in bond_3ad.h
Date: Sat,  9 May 2009 18:59:16 +0200
Message-Id: <1241888356-7575-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETH_P_SLOW is already defined in include/linux/if_ether.h.
There's no need to define BOND_ETH_P_LACPDU in drivers/net/bonding/bond_3ad.h

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/net/bonding/bond_3ad.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index a306230..2c46a15 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -26,10 +26,10 @@
 #include <asm/byteorder.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/if_ether.h>
 
 // General definitions
-#define BOND_ETH_P_LACPDU       0x8809
-#define PKT_TYPE_LACPDU         cpu_to_be16(BOND_ETH_P_LACPDU)
+#define PKT_TYPE_LACPDU         cpu_to_be16(ETH_P_SLOW)
 #define AD_TIMER_INTERVAL       100 /*msec*/
 
 #define MULTICAST_LACPDU_ADDR    {0x01, 0x80, 0xC2, 0x00, 0x00, 0x02}
-- 
1.6.0.4

