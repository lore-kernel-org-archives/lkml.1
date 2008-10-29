Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYJ2XA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYJ2XA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYJ2Wqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:36 -0400
Received: from kroah.org ([198.145.64.141]:56294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756512AbYJ2Wq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:26 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "J.R. Mauro" <jrm8005@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/49] Staging: sxg: break the build in a cleaner way when !x86
Date: Wed, 29 Oct 2008 15:40:13 -0700
Message-Id: <1225320016-21803-46-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J.R. Mauro <jrm8005@gmail.com>

Remove ugly 'Stop Comilation;' statement in sxghif, replace with an
error macro.

This should never be hit as we are only building for x86 boxes at the
moment.

Signed-off by: J.R. Mauro <jrm8005@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/sxg/sxghif.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sxg/sxghif.h b/drivers/staging/sxg/sxghif.h
index bca93fc..a4e9468 100644
--- a/drivers/staging/sxg/sxghif.h
+++ b/drivers/staging/sxg/sxghif.h
@@ -854,5 +854,5 @@ struct SXG_SCATTER_GATHER {
 #define SXG_SGL_BUFFER(_SxgSgl)		NULL
 #define SXG_SGL_BUF_SIZE			0
 #else
-Stop Compilation;
+#error staging: sxg: driver is for X86 only!
 #endif
-- 
1.6.0.2

