Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYGDQtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYGDQtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYGDQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:49:10 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:49876 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbYGDQtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tfiD6+H7CKgVZic/Z9OA6Dr9qRS3BO1qNcNvpBHa5/KQwqTyyWX8VBpTpaeJeACtTk
         29X6rstioBPunpazGdLXlHFA2m5lz0NzuCV10ZKse01r8NCMvD9n5xVZKgJ+3fPssHbq
         AIlAfI86MxdYeQwIrcV/FvZ7nihQQ613BxbrU=
Date: Sat, 5 Jul 2008 01:48:59 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: [PATCH -mm] fix s390-use-memory_read_from_buffer.patch
Message-ID: <20080704164858.GA22477@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org> <1215182555.5413.8.camel@localhost.localdomain> <20080704163942.GA15214@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080704163942.GA15214@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Holzheu <holzheu@de.ibm.com>
---
 arch/s390/kernel/ipl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/arch/s390/kernel/ipl.c
===================================================================
--- 2.6-mm.orig/arch/s390/kernel/ipl.c
+++ 2.6-mm/arch/s390/kernel/ipl.c
@@ -14,7 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
-#include <linux/fs.h>
+#include <linux/string.h>
 #include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
