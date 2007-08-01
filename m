Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbXHARyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbXHARyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764707AbXHARxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:53:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42171 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764640AbXHARxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=hrrbx2aZ6ofAonf7zcpGCmjPzXNCIW6LMkvsyykl9aYSLOBGX8OE6XOFgLKSBisa4UEDdcRKi+N8AR5pdFDCcjMaXwm1XXSYGWMtrfsJK800wreiIRY4DGZcXTBY/+0uI9SbNbs2jXPcjKEZb+1mtKmK4f+YOUF3zizL24tNXv0=
Message-ID: <46B0C88B.4020905@googlemail.com>
Date: Wed, 01 Aug 2007 19:53:15 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Jon Mason <jdmason@kudzu.us>,
       discuss@x86-64.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Removal of duplicated include arch/x86_64/kernel/pci-calgary.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is no need to include linux/init.h twice

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/arch/x86_64/kernel/pci-calgary.c	2007-08-01 16:39:29.000000000 +0200
+++ linux-mm/arch/x86_64/kernel/pci-calgary.c	2007-08-01 18:23:45.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
