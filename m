Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYCWIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYCWIay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759015AbYCWIJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:45 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2286 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbYCWIJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:42 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 144/148] include/asm-x86/vmi.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:59 -0700
Message-Id: <1206259443-13210-145-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/vmi.h |   88 ++++++++++++++++++++++++------------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/include/asm-x86/vmi.h b/include/asm-x86/vmi.h
index eb8bd89..b7c0dea 100644
--- a/include/asm-x86/vmi.h
+++ b/include/asm-x86/vmi.h
@@ -155,9 +155,9 @@
 
 #ifndef __ASSEMBLY__
 struct vmi_relocation_info {
-        unsigned char           *eip;
-        unsigned char           type;
-        unsigned char           reserved[3];
+	unsigned char           *eip;
+	unsigned char           type;
+	unsigned char           reserved[3];
 };
 #endif
 
@@ -173,53 +173,53 @@ struct vmi_relocation_info {
 #ifndef __ASSEMBLY__
 
 struct vrom_header {
-	u16     rom_signature;  // option ROM signature
-	u8      rom_length;     // ROM length in 512 byte chunks
-	u8      rom_entry[4];   // 16-bit code entry point
-	u8      rom_pad0;       // 4-byte align pad
-	u32     vrom_signature; // VROM identification signature
-	u8      api_version_min;// Minor version of API
-	u8      api_version_maj;// Major version of API
-	u8      jump_slots;     // Number of jump slots
-	u8      reserved1;      // Reserved for expansion
-	u32     virtual_top;    // Hypervisor virtual address start
-	u16     reserved2;      // Reserved for expansion
-	u16	license_offs;	// Offset to License string
-	u16     pci_header_offs;// Offset to PCI OPROM header
-	u16     pnp_header_offs;// Offset to PnP OPROM header
-	u32     rom_pad3;       // PnP reserverd / VMI reserved
-	u8      reserved[96];   // Reserved for headers
-	char    vmi_init[8];    // VMI_Init jump point
-	char    get_reloc[8];   // VMI_GetRelocationInfo jump point
+	u16     rom_signature;  /* option ROM signature */
+	u8      rom_length;     /* ROM length in 512 byte chunks */
+	u8      rom_entry[4];   /* 16-bit code entry point */
+	u8      rom_pad0;       /* 4-byte align pad */
+	u32     vrom_signature; /* VROM identification signature */
+	u8      api_version_min;/* Minor version of API */
+	u8      api_version_maj;/* Major version of API */
+	u8      jump_slots;     /* Number of jump slots */
+	u8      reserved1;      /* Reserved for expansion */
+	u32     virtual_top;    /* Hypervisor virtual address start */
+	u16     reserved2;      /* Reserved for expansion */
+	u16	license_offs;	/* Offset to License string */
+	u16     pci_header_offs;/* Offset to PCI OPROM header */
+	u16     pnp_header_offs;/* Offset to PnP OPROM header */
+	u32     rom_pad3;       /* PnP reserverd / VMI reserved */
+	u8      reserved[96];   /* Reserved for headers */
+	char    vmi_init[8];    /* VMI_Init jump point */
+	char    get_reloc[8];   /* VMI_GetRelocationInfo jump point */
 } __attribute__((packed));
 
 struct pnp_header {
-        char sig[4];
-        char rev;
-        char size;
-        short next;
-        short res;
-        long devID;
-        unsigned short manufacturer_offset;
-        unsigned short product_offset;
+	char sig[4];
+	char rev;
+	char size;
+	short next;
+	short res;
+	long devID;
+	unsigned short manufacturer_offset;
+	unsigned short product_offset;
 } __attribute__((packed));
 
 struct pci_header {
-        char sig[4];
-        short vendorID;
-        short deviceID;
-        short vpdData;
-        short size;
-        char rev;
-        char class;
-        char subclass;
-        char interface;
-        short chunks;
-        char rom_version_min;
-        char rom_version_maj;
-        char codetype;
-        char lastRom;
-        short reserved;
+	char sig[4];
+	short vendorID;
+	short deviceID;
+	short vpdData;
+	short size;
+	char rev;
+	char class;
+	char subclass;
+	char interface;
+	short chunks;
+	char rom_version_min;
+	char rom_version_maj;
+	char codetype;
+	char lastRom;
+	short reserved;
 } __attribute__((packed));
 
 /* Function prototypes for bootstrapping */
-- 
1.5.4.rc2

