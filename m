Return-Path: <linux-kernel-owner+w=401wt.eu-S1030180AbXCGO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030180AbXCGO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXCGO2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:28:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030180AbXCGO2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:28:53 -0500
Subject: [DLM] fs/dlm/user.c should #include "user.h" [5/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:29:47 +0000
Message-Id: <1173277787.11001.762.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 84c6e8cd359adc34d21e40efcafe09297510b3c8 Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 26 Feb 2007 00:18:42 +0100
Subject: [PATCH] [DLM] fs/dlm/user.c should #include "user.h"

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 40db61d..3870150 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -22,6 +22,7 @@
 #include "lockspace.h"
 #include "lock.h"
 #include "lvb_table.h"
+#include "user.h"
 
 static const char *name_prefix="dlm";
 static struct miscdevice ctl_device;
-- 
1.4.4.2



