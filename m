Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0BTAFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:05:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55262 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab0BTAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dno2rHudLXMjZ2LePY7+hK+AzfbW9Oal/YluKvlEKZJFt4g06buj/Hl7h/uXEYCOYJ
         jWjMRdHgcb6zz19+XxDE1eGBRQlPkbag/Ad+JmS/Fj+TKQZD6u7ZaVRgGwCVFLucaaGa
         qK6MDHL6BIUOsNqS5kiTMPjROB7s8f+2mIZ0k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 21/24] Rename .data.initvect to .data..initvect.
Date: Sat, 20 Feb 2010 01:03:54 +0100
Message-Id: <1266624237-22372-22-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S      |    2 +-
 arch/m68knommu/platform/68360/head-ram.S |    2 +-
 arch/m68knommu/platform/68360/head-rom.S |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index fd3df56..a91b271 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -57,7 +57,7 @@ SECTIONS {
 	.romvec : {
 		__rom_start = . ;
 		_romvec = .;
-		*(.data.initvect)
+		*(.data..initvect)
 	} > romvec
 #endif
 
diff --git a/arch/m68knommu/platform/68360/head-ram.S b/arch/m68knommu/platform/68360/head-ram.S
index 2ef0624..8eb94fb 100644
--- a/arch/m68knommu/platform/68360/head-ram.S
+++ b/arch/m68knommu/platform/68360/head-ram.S
@@ -280,7 +280,7 @@ _dprbase:
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".data..initvect","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
diff --git a/arch/m68knommu/platform/68360/head-rom.S b/arch/m68knommu/platform/68360/head-rom.S
index 62ecf41..97510e5 100644
--- a/arch/m68knommu/platform/68360/head-rom.S
+++ b/arch/m68knommu/platform/68360/head-rom.S
@@ -291,7 +291,7 @@ _dprbase:
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".data..initvect","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
-- 
1.6.2.4

