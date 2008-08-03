Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYHCDIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYHCDIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYHCDBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:01:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbYHCDBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sXWbia9n4Hl5WpXgHE1UD5xZEufdQ4EHLgE4KXlmgtzro0NZigrDUMMvkLPA/j/pvF
         fTzJEuvHaT7LsHx+S0k9RCd8TPLk0mEcgzq7+rbwnb80gTkZHdORBhR+Z4SsOt2IbIBw
         +V5dr6Sw0KqLxiFkUHv9dUGGRI4F+y3XCERyA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 25/25] x86: remove nr_irq_vectors
Date: Sat,  2 Aug 2008 19:59:25 -0700
Message-Id: <1217732365-16595-26-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-25-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-23-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-24-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-25-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/asm-x86/irq_vectors.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 0817a19..821ff99 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -127,8 +127,6 @@
 
 #endif /* VISWS */
 
-#define NR_IRQ_VECTORS		NR_IRQS
-
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
 #define VIC_CPI_LEVEL0			0
-- 
1.5.4.5

