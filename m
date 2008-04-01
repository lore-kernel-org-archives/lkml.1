Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYDARbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYDARbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYDARbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:31:32 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:42060 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbYDARbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:31:31 -0400
Message-ID: <47F27155.1000103@tiscali.nl>
Date: Tue, 01 Apr 2008 19:31:01 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: paulus@samba.org
CC: linuxppc-dev@ozlabs.org, trivial@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] powerpc: replace `__attribute' by `__attribute__'
References: <47F26FF6.8070300@tiscali.nl>
In-Reply-To: <47F26FF6.8070300@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace `__attribute' by `__attribute__'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/platforms/iseries/main_store.h b/arch/powerpc/platforms/iseries/main_store.h
index 1a7a3f5..976b23e 100644
--- a/arch/powerpc/platforms/iseries/main_store.h
+++ b/arch/powerpc/platforms/iseries/main_store.h
@@ -61,7 +61,7 @@ struct IoHriMainStoreSegment4 {
 };
 
 /* Main Store VPD for Power4 */
-struct __attribute((packed)) IoHriMainStoreChipInfo1 {
+struct __attribute__((packed)) IoHriMainStoreChipInfo1 {
 	u32	chipMfgID;
 	char	chipECLevel[4];
 };
@@ -73,14 +73,14 @@ struct IoHriMainStoreVpdIdData {
 	char	serialNumber[12];
 };
 
-struct	__attribute((packed)) IoHriMainStoreVpdFruData {
+struct	__attribute__((packed)) IoHriMainStoreVpdFruData {
 	char	fruLabel[8];
 	u8	numberOfSlots;
 	u8	pluggingType;
 	u16	slotMapIndex;
 };
 
-struct  __attribute((packed)) IoHriMainStoreAdrRangeBlock {
+struct  __attribute__((packed)) IoHriMainStoreAdrRangeBlock {
 	void	*blockStart;
 	void	*blockEnd;
 	u32	blockProcChipId;
@@ -88,7 +88,7 @@ struct  __attribute((packed)) IoHriMainStoreAdrRangeBlock {
 
 #define MaxAreaAdrRangeBlocks 4
 
-struct __attribute((packed)) IoHriMainStoreArea4 {
+struct __attribute__((packed)) IoHriMainStoreArea4 {
 	u32	msVpdFormat;
 	u8	containedVpdType;
 	u8	reserved1;

