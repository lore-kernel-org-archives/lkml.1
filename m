Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab0COAkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:40:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60099 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab0COAkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nhXe5OckBdMsganTIQj+kXB5K4qrhZaHbrmyRwmS+9w5d4DmlD/pAPLCGvy0YIjWZT
         xuiD+0I7JSPwlxsulHjoxOs2A2HFS7PL+3j33r1Lo276msdk0YyaY4qCFpYy3BhTEIc1
         YRPv1naOqjXwp3mHcojojFHbyNCvBWctPfCkM=
From: Vikram Dhillon <dhillonv10@gmail.com>
To: gregkh@suse.de
Cc: andrea.gelmini@gelma.net, linville@tuxdriver.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Vikram Dhillon <dhillonv10@gmail.com>
Subject: [PATCH] Staging: arlan: arlan.h: Fixed some style issues
Date: Sun, 14 Mar 2010 20:39:30 -0400
Message-Id: <1268613570-8975-1-git-send-email-dhillonv10@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style issues in accordance with checkpatch.pl. Before the patch contained "total: 2 errors, 186 warnings, 535 lines checked" and now it has: total: 0 errors, 170 warnings. Most of the warnings that remain now are the line over 80 chars ones. This is my first patch, so please take it easy on me :)

Signed-off-by: Vikram Dhillon <dhillonv10@gmail.com>
---
 drivers/staging/arlan/arlan.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/arlan/arlan.h b/drivers/staging/arlan/arlan.h
index ffcd3ea..3974acf 100644
--- a/drivers/staging/arlan/arlan.h
+++ b/drivers/staging/arlan/arlan.h
@@ -318,7 +318,7 @@ extern struct arlan_conf_stru arlan_conf[MAX_ARLANS];
 struct TxParam {
       volatile	short 		offset;
       volatile 	short 		length;
-      volatile	u_char 		dest[6];
+      volatile	u_char	dest[6];
       volatile	unsigned	char clear;
       volatile	unsigned	char retries;
       volatile	unsigned	char routing;
@@ -354,37 +354,37 @@ struct arlan_private {
       unsigned long	tx_last_sent;
       unsigned long	tx_last_cleared;
       unsigned long	retransmissions;
-      unsigned long 	interrupt_ack_requested;
+      unsigned long	interrupt_ack_requested;
       spinlock_t	lock;
       unsigned long	waiting_command_mask;
-      unsigned long 	card_polling_interval;
-      unsigned long 	last_command_buff_free_time;
+      unsigned long	card_polling_interval;
+      unsigned long	last_command_buff_free_time;

-      int 		under_reset;
-      int 		under_config;
-      int 		rx_command_given;
-      int	 	tx_command_given;
+      int		under_reset;
+      int		under_config;
+      int		rx_command_given;
+      int		tx_command_given;
       unsigned  long	interrupt_processing_active;
       unsigned long	last_rx_int_ack_time;
       unsigned long	in_bytes;
-      unsigned long 	out_bytes;
+      unsigned long	out_bytes;
       unsigned long	in_time;
       unsigned long	out_time;
       unsigned long	in_time10;
       unsigned long	out_time10;
       unsigned long	in_bytes10;
-      unsigned long 	out_bytes10;
+      unsigned long	out_bytes10;
       int	init_etherdev_alloc;
 };



 #define ARLAN_CLEAR		0x00
-#define ARLAN_RESET 		0x01
+#define ARLAN_RESET		0x01
 #define ARLAN_CHANNEL_ATTENTION 0x02
-#define ARLAN_INTERRUPT_ENABLE 	0x04
-#define ARLAN_CLEAR_INTERRUPT 	0x08
-#define ARLAN_POWER 		0x40
+#define ARLAN_INTERRUPT_ENABLE	0x04
+#define ARLAN_CLEAR_INTERRUPT	0x08
+#define ARLAN_POWER		0x40
 #define ARLAN_ACCESS		0x80

 #define ARLAN_COM_CONF                0x01
@@ -445,8 +445,8 @@ struct arlan_private {


 #define registrationBad(dev)\
-    ((   READSHMB(((struct arlan_private *)netdev_priv(dev))->card->registrationMode)    > 0) && \
-     (   READSHMB(((struct arlan_private *)netdev_priv(dev))->card->registrationStatus) == 0))
+    ((READSHMB(((struct arlan_private *)netdev_priv(dev))->card->registrationMode)    > 0) && \
+     (READSHMB(((struct arlan_private *)netdev_priv(dev))->card->registrationStatus) == 0))


 #define readControlRegister(dev)\
@@ -461,9 +461,9 @@ struct arlan_private {
    int cr;   \
    \
    cr = readControlRegister(dev);\
-   if (cr & ARLAN_CHANNEL_ATTENTION) { \
+   if (cr & ARLAN_CHANNEL_ATTENTION) \
       writeControlRegister(dev, (cr & ~ARLAN_CHANNEL_ATTENTION));\
-   } else  \
+   else \
       writeControlRegister(dev, (cr | ARLAN_CHANNEL_ATTENTION));\
 }

@@ -504,8 +504,8 @@ struct arlan_private {
 #define ARLAN_COMMAND_RX_ABORT		0x000080
 #define ARLAN_COMMAND_POWERDOWN		0x000100
 #define ARLAN_COMMAND_POWERUP		0x000200
-#define ARLAN_COMMAND_SLOW_POLL 	0x000400
-#define ARLAN_COMMAND_ACTIVATE 		0x000800
+#define ARLAN_COMMAND_SLOW_POLL	0x000400
+#define ARLAN_COMMAND_ACTIVATE	0x000800
 #define ARLAN_COMMAND_INT_ACK		0x001000
 #define ARLAN_COMMAND_INT_ENABLE	0x002000
 #define ARLAN_COMMAND_WAIT_NOW		0x004000
--
1.6.3.3

