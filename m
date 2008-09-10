Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYIJLWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYIJLWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYIJLVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:21:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:34332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYIJLVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:21:39 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       "David S. Miller" <davem@davemloft.net>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH] include <linux/types.h> into linux/if_addrlabel.h for __u* typedef
Date: Wed, 10 Sep 2008 14:22:05 +0300
Message-Id: <1221045726-5674-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
In-Reply-To: <1221045726-5674-2-git-send-email-kirill@shutemov.name>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
 <1221045726-5674-2-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: David S. Miller <davem@davemloft.net>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 include/linux/if_addrlabel.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_addrlabel.h b/include/linux/if_addrlabel.h
index 9fe79c9..89571f6 100644
--- a/include/linux/if_addrlabel.h
+++ b/include/linux/if_addrlabel.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_IF_ADDRLABEL_H
 #define __LINUX_IF_ADDRLABEL_H
 
+#include <linux/types.h>
+
 struct ifaddrlblmsg
 {
 	__u8		ifal_family;		/* Address family */
-- 
1.5.6.5.GIT

