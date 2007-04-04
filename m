Return-Path: <linux-kernel-owner+w=401wt.eu-S2992947AbXDDPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992947AbXDDPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992952AbXDDPZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:25:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42721 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992943AbXDDPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:25:29 -0400
Date: Wed, 4 Apr 2007 17:25:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: pcaulfie@redhat.com, teigland@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/dlm/ast.c should #include "ast.h"
Message-ID: <20070404152529.GI27660@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm3/fs/dlm/ast.c.old	2007-04-03 01:45:23.000000000 +0200
+++ linux-2.6.21-rc5-mm3/fs/dlm/ast.c	2007-04-03 01:45:36.000000000 +0200
@@ -14,6 +14,7 @@
 #include "dlm_internal.h"
 #include "lock.h"
 #include "user.h"
+#include "ast.h"
 
 #define WAKE_ASTS  0
 

