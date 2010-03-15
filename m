Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0COD3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:29:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45493 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0COD3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pHW7aCGpb7vKmUdDOJDIYPAJAe3FNTVj3CEkOd3t27aYvSZaO8dSICkC1/X/9Cb/Vk
         LCxdIAEjHt3KLEUXmzYL4WtCZcyXET0XgQ+mNMYciEGS/GTTJmxTV/jFjBV0bFIcYSCq
         CiDkm3IHMKdC3/xKgzTQGfrOAPuNItQm/QEg8=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream: smd: smd_private: fix code style issues
Date: Mon, 15 Mar 2010 00:29:02 -0300
Message-Id: <1268623742-10872-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This put open braces '{' following structs on the same line.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/smd/smd_private.h |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/dream/smd/smd_private.h b/drivers/staging/dream/smd/smd_private.h
index c0eb3de..1b2e1c8 100644
--- a/drivers/staging/dream/smd/smd_private.h
+++ b/drivers/staging/dream/smd/smd_private.h
@@ -16,24 +16,21 @@
 #ifndef _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
 #define _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
 
-struct smem_heap_info
-{
+struct smem_heap_info {
 	unsigned initialized;
 	unsigned free_offset;
 	unsigned heap_remaining;
 	unsigned reserved;
 };
 
-struct smem_heap_entry
-{
+struct smem_heap_entry {
 	unsigned allocated;
 	unsigned offset;
 	unsigned size;
 	unsigned reserved;
 };
 
-struct smem_proc_comm
-{
+struct smem_proc_comm {
 	unsigned command;
 	unsigned status;
 	unsigned data1;
@@ -49,22 +46,19 @@ struct smem_proc_comm
 #define VERSION_APPS      8
 #define VERSION_MODEM     9
 
-struct smem_shared
-{
+struct smem_shared {
 	struct smem_proc_comm proc_comm[4];
 	unsigned version[32];
 	struct smem_heap_info heap_info;
 	struct smem_heap_entry heap_toc[128];
 };
 
-struct smsm_shared
-{
+struct smsm_shared {
 	unsigned host;
 	unsigned state;
 };
 
-struct smsm_interrupt_info
-{
+struct smsm_interrupt_info {
 	uint32_t aArm_en_mask;
 	uint32_t aArm_interrupts_pending;
 	uint32_t aArm_wakeup_reason;
@@ -108,8 +102,7 @@ void smsm_print_sleep_info(void);
 
 #define SMEM_NUM_SMD_CHANNELS        64
 
-typedef enum
-{
+typedef enum {
 	/* fixed items */
 	SMEM_PROC_COMM = 0,
 	SMEM_HEAP_INFO,
-- 
1.5.6.3

