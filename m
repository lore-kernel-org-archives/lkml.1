Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbYGDQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbYGDQzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbYGDQvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28184 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbYGDQvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oisZbKURNGN2+pzItM/Ee+KR4c5X/Ggdm5OP9K00nrosgyp8p06mKNY/pzcVJH1JJh
         lKbaxlNRPxtz3u3jCsRBBjaXLkwVGsDLFEkgoPYp6hOOkDho7mSOW3m/JlI5gErp42yi
         IDPrrFEjkMcjB2PFaar3GlU3qKD75dgcRRXi8=
Date: Sat, 5 Jul 2008 01:51:37 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: [PATCH -mm] fix s390-cio-use-memory_read_from_buffer.patch
Message-ID: <20080704165136.GB22477@localhost.localdomain>
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
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 drivers/s390/cio/chp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/drivers/s390/cio/chp.c
===================================================================
--- 2.6-mm.orig/drivers/s390/cio/chp.c
+++ 2.6-mm/drivers/s390/cio/chp.c
@@ -15,7 +15,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/errno.h>
-#include <linux/fs.h>
+#include <linux/string.h>
 #include <asm/chpid.h>
 #include <asm/sclp.h>
 
