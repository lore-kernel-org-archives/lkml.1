Return-Path: <linux-kernel-owner+w=401wt.eu-S2992992AbXDDQgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992992AbXDDQgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992994AbXDDQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:36:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:64234 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992992AbXDDQgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=F04JyV+j6m3YLEIbp/gecxkfaW07yhXK+S2OQxF0oAw/BbHuV/QrI4oL9AhyKRScKJssAnJWWgAXn2AmHpJ0EsEYiqtqk5d8BJbgQrVw/tivGbo5kufqk7iFlYNnXwDk+pMACZYNtLycLdU/2OBlqqsmuslaT/wI57OrSMdJHWo=
Date: Wed, 4 Apr 2007 22:07:40 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: [KJ][PATCH]Unused ROUND_UP, NAME_OFFSET macro in arch/powerpc
Message-ID: <20070404163740.GA9830@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unused ROUND_UP, NAME_OFFSET  macro cleanup

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 sys_ppc32.c |    4 ----
 1 files changed, 4 deletions(-)


diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 673e8d9..047246a 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -53,10 +53,6 @@
 #include <asm/ppc-pci.h>
 #include <asm/syscalls.h>
 
-/* readdir & getdents */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(u32)-1) & ~(sizeof(u32)-1))
-
 struct old_linux_dirent32 {
 	u32		d_ino;
 	u32		d_offset;
-- 
Milind Arun Choudhary
