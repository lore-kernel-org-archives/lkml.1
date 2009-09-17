Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZIQMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZIQMxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZIQMxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:53:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11219 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZIQMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=shvGJ5TRpHIW88q/KlZhFMWRTXBpG2jNvKZvqCIt30aa9OBStVxH3a8II9fldlhZqD
         yRm/6EGiKDFdB3QAZk+177njFgAagFdXG70QXMrVGDjgQU9ndOlkqdSbHkqZBXyfGkmI
         r69OlAhANOUv0VUX7iqOFWR7Q0ASi4VoigicY=
Date: Thu, 17 Sep 2009 15:54:01 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 uaccess_32.h typo
Message-ID: <20090917125401.GU3717@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial: correct "that the we don't" typo. 

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 5e06259..632fb44 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -33,7 +33,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
  * The caller should also make sure he pins the user space address
- * so that the we don't result in page fault and sleep.
+ * so that we don't result in page fault and sleep.
  *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.

