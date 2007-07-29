Return-Path: <linux-kernel-owner+w=401wt.eu-S965477AbXG2Wpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477AbXG2Wpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXG2Wpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:45:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:43788 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbXG2Wpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ObLf5Qy49Y6lUH7zZGh9e3wFwCZXf6cKoDjtS9i+CyDUdJa8jjK358mmRKIEMkBVjoQFM7tVzzHgRKmgmM8ZgX/M2SkGvN/uIse+GqVvLlFXAnxNSciGGTwiXrKzYqht7uNUXbJ465bDsfTX04LBgcfVpnCxh9um7bgxZ3MNcm8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] sh64: arch/sh64/kernel/signal.h - duplicate include removal
Date: Mon, 30 Jul 2007 00:44:00 +0200
User-Agent: KMail/1.9.7
Cc: Richard Curnow <rc@rc0.org.uk>, linuxsh-shmedia-dev@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707300044.00606.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch removes the duplicate inclusion of linux/personality.h 
from arch/sh64/kernel/signal.c


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/sh64/kernel/signal.c b/arch/sh64/kernel/signal.c
index 0bb4a8f..79fc48c 100644
--- a/arch/sh64/kernel/signal.c
+++ b/arch/sh64/kernel/signal.c
@@ -25,7 +25,6 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>

