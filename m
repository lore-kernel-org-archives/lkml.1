Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYJRDwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYJRDwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYJRDwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:52:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:37271 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYJRDwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=AiKUhkeOxBp1SMdJmhV73nYPvJC8GLpYBu4OR9dcQD5aQ1Mf2Xg9QoMJqbTIr7XeBi
         RvdwCF1Vtt3h48c4BONJNNolm/4JMccKPCjU/X+qTC65kvZkJq+PH4ygmUmsFubc75wN
         KJaqwZEI/j9BHiJJkNaMxRuQoPu2yJ2d2V2t0=
Date: Sat, 18 Oct 2008 11:52:15 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: me4000: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018113833.61B4.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in drivers/staging/me4000/me4000.c
   asm/uaccess.h
   linux/fs.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 862dd7f..90de6f0 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -30,7 +30,6 @@
 #include <asm/uaccess.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/unistd.h>
 #include <linux/list.h>
@@ -39,7 +38,6 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <asm/pgtable.h>
-#include <asm/uaccess.h>
 #include <linux/types.h>

 #include <linux/slab.h>


