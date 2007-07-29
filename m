Return-Path: <linux-kernel-owner+w=401wt.eu-S937206AbXG2Vzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937206AbXG2Vzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935349AbXG2Vz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:55:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:10365 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935348AbXG2Vz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Cc1Yq+5wdbKU6pUYyvht4ThN1WGoQrqssbMl/uRImSH0vKMBaji5kBZyJC58xkB3byaD1cDzBcHub6tQJ9OnO/jSlo8V5DBfZAkAJCHcWjkNwmV9/9F+yCcW95aF8n0u4ihxhXmT9Mad30ZhIrr2RFcBR9tRAWbZs6uvzcXdAZU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] m68knommu: Get rid of duplicate include
Date: Sun, 29 Jul 2007 23:53:54 +0200
User-Agent: KMail/1.9.7
Cc: Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292353.55129.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch removes the duplicate inclusion of asm/irq.h 
from arch/m68knommu/platform/5206e/config.c


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/m68knommu/platform/5206e/config.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
index 4ab614f..425703f 100644
--- a/arch/m68knommu/platform/5206e/config.c
+++ b/arch/m68knommu/platform/5206e/config.c
@@ -20,7 +20,6 @@
 #include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
-#include <asm/irq.h>
 
 /***************************************************************************/
 


