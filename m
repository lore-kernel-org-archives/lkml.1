Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbXHARvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbXHARvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbXHARul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:50:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:33148 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796AbXHARuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FiCdBEGypFqC993sqC+sqr6kBGPuPgsZIErTWKaw3YoVGaNZ1Rik0iQN4ydaXJdbnQ3w7R9iT7OqHGhRGrrLcvirbqCBvPR9inEIKuku6agxnCkAe9uRbUR9hTYe/Op5tt24FG058vM+vUpZFQPROJVYDyOdjKVWciJPnFgu9z8=
Message-ID: <46B0C7D1.3070801@googlemail.com>
Date: Wed, 01 Aug 2007 19:50:09 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       linuxsh-shmedia-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Removal of duplicated include arch/sh64/kernel/setup.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is no need to include linux/console.h twice

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/arch/sh64/kernel/setup.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/arch/sh64/kernel/setup.c	2007-08-01 18:27:08.000000000 +0200
@@ -59,10 +59,6 @@
 #include <asm/setup.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_VT
-#include <linux/console.h>
-#endif
-
 struct screen_info screen_info;
 
 #ifdef CONFIG_BLK_DEV_RAM
