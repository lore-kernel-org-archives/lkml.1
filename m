Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZEVEzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZEVEzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZEVEzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZEVEzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Phk3OisJ9jqfXhkaWH7ol3y0WiNDNk/DxNhhh/8nv02C3XPFhwEntXIzaOzfex2n1B
         /K6c10s+bLLgxKKlX1WXdnTcOtoEZyT24qpmiuCkKolBfcQM16ZfVZtsathKb0HgtPTs
         2OyIh04uts1pBPKJqsgK82MR+tNxteArx3TbE=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 01/38] cred: #include init.h in cred.h
Date: Fri, 22 May 2009 08:54:55 +0400
Message-Id: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cred.h can't be included as first header because it uses __init and
doesn't include init.h which is enough to break compilation on at least
ia64.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/cred.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 3282ee4..4fa9996 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -13,6 +13,7 @@
 #define _LINUX_CRED_H
 
 #include <linux/capability.h>
+#include <linux/init.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
 
-- 
1.5.6.5

