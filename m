Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbZDJCc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbZDJCc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZDJCcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:32:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbZDJCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nHjJ59/i8UYdFCe1UXBjcMsOKNTYuVIf5mM2U/WM0DhbA+IezLEBysBQX7VeyJGrnA
         w/+Uekf2GE2l02ufgCdqMTdMNEFoHpQfAHOKNfpXxY0GtCDwBdoyuHcSgOvRYskL4F0+
         XhFVsHoMxgqy3z6mvorI3dxmndd8mP8KfZP2g=
Date: Fri, 10 Apr 2009 06:32:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/30] headers: fixup cred.h, ipc_namespace.h
Message-ID: <20090410023248.GB27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cred.h uses __init
ipc_namespace.h uses kern_ipc_perm.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cred.h          |    1 +
 include/linux/ipc_namespace.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -13,6 +13,7 @@
 #define _LINUX_CRED_H
 
 #include <linux/capability.h>
+#include <linux/init.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
 
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -6,6 +6,8 @@
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
 
+struct kern_ipc_perm;
+
 /*
  * ipc namespace events
  */
