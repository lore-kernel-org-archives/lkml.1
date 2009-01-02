Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbZABXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbZABXjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZABXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:38:55 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17452 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZABXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:38:55 -0500
Date: Sat, 3 Jan 2009 00:38:52 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Do not include linux/irqnr.h twice in
 include/linux/interrupt.h
Message-ID: <alpine.LNX.2.00.0901030035330.5463@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Including the linux/irqnr.h header twice in include/linux/interrupt.h is 
pointless - let's not.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 990355f..d9022cb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -14,7 +14,6 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
-#include <linux/irqnr.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>


-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

