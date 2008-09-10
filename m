Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYIJLWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYIJLWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYIJLVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:21:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27847 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYIJLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:21:36 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] include <linux/types.h> into linux/dlm_plock.h for __u* typedef
Date: Wed, 10 Sep 2008 14:22:04 +0300
Message-Id: <1221045726-5674-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
In-Reply-To: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Christine Caulfield <caulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/dlm_plock.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/dlm_plock.h b/include/linux/dlm_plock.h
index 18d5fdb..2dd2124 100644
--- a/include/linux/dlm_plock.h
+++ b/include/linux/dlm_plock.h
@@ -9,6 +9,8 @@
 #ifndef __DLM_PLOCK_DOT_H__
 #define __DLM_PLOCK_DOT_H__
 
+#include <linux/types.h>
+
 #define DLM_PLOCK_MISC_NAME		"dlm_plock"
 
 #define DLM_PLOCK_VERSION_MAJOR	1
-- 
1.5.6.5.GIT

