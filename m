Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYAQSQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYAQSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYAQSQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:16:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60987 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYAQSQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:16:50 -0500
Date: Thu, 17 Jan 2008 10:16:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: phil.el@wanadoo.fr, mingo@elte.hu
Subject: x86: Add support for the latest Intel processors to Oprofile
Message-ID: <20080117101613.65bf008b@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: Add support for the latest Intel processors to Oprofile
From: Arjan van de Ven <arjan@linux.intel.com>

The latest Intel processors (the 45nm ones) have a model number of 23
(old ones had 15); they're otherwise compatible on the oprofile side.
This patch adds the new model number to the oprofile code.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc7-oprofile/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6.24-rc7-oprofile.orig/arch/x86/oprofile/nmi_int.c
+++ linux-2.6.24-rc7-oprofile/arch/x86/oprofile/nmi_int.c
@@ -380,7 +380,7 @@ static int __init ppro_init(char ** cpu_
 
 	if (cpu_model == 14)
 		*cpu_type = "i386/core";
-	else if (cpu_model == 15)
+	else if (cpu_model == 15 || cpu_model == 23)
 		*cpu_type = "i386/core_2";
 	else if (cpu_model > 0xd)
 		return 0;

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
