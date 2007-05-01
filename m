Return-Path: <linux-kernel-owner+w=401wt.eu-S1161677AbXEAKXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161677AbXEAKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161686AbXEAKXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:23:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161677AbXEAKXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:23:45 -0400
Subject: DLM] fs/dlm/ast.c should #include "ast.h" [23/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:17:09 +0100
Message-Id: <1178014629.5462.175.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8fa1de386f4d72f0710b389ccf96308fef87df78 Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@stusta.de>
Date: Wed, 4 Apr 2007 17:25:29 +0200
Subject: [PATCH] [DLM] fs/dlm/ast.c should #include "ast.h"

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index f91d39c..6308122 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -14,6 +14,7 @@
 #include "dlm_internal.h"
 #include "lock.h"
 #include "user.h"
+#include "ast.h"
 
 #define WAKE_ASTS  0
 
-- 
1.5.1.2



