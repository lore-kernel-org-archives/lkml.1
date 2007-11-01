Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXKARSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXKARSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbXKARSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:18:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54229 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXKARR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Pi0YlQMKbwxJJmc1O/lM3dHTW/M6AwzgHXKQXLOvCQmti1Kqidsy+MAZhZlI3lpzE2Kfe3/vdHVZf/rJ5dh5L4LpC0gpU12TCGDqM2p078k/8kZVdZxWqdUgQ3B4FlnHB7ufISRy5ANOAYqaSZqu/G31d3l0znc8dOHWtzAeCPg=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove duplicated #include entry
Date: Thu, 1 Nov 2007 18:17:47 +0100
User-Agent: KMail/1.9.7
Cc: tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711011817.47895.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"#include <linux/kprobes.h>" is duplicated in "arch/x86/mm/fault_32.c".
We just remove one of the entries.

Signed-off-by: Miguel Botón <mboton@gmail.com>


Index: linux-2.6.24-rc1/arch/x86/mm/fault_32.c
===================================================================
--- linux-2.6.24-rc1.orig/arch/x86/mm/fault_32.c
+++ linux-2.6.24-rc1/arch/x86/mm/fault_32.c
@@ -22,7 +22,6 @@
 #include <linux/bootmem.h>		/* for max_low_pfn */
 #include <linux/vmalloc.h>
 #include <linux/module.h>
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
 #include <linux/kprobes.h>

-- 
	Miguel Botón
