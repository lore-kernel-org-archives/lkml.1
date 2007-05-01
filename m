Return-Path: <linux-kernel-owner+w=401wt.eu-S1161687AbXEAKUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161687AbXEAKUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161686AbXEAKUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:20:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161680AbXEAKUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:20:09 -0400
Subject: [DLM] Remove redundant assignment [21/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:15:35 +0100
Message-Id: <1178014535.5462.171.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From fc7c44f03d95f20b5446d06f5bb9605cddd53203 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Tue, 10 Apr 2007 09:40:19 +0100
Subject: [PATCH] [DLM] Remove redundant assignment

This patch removes a redundant (and incorrect) assignment from compat_output

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 3e746a6..b0201ec 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -115,8 +115,6 @@ static void compat_input(struct dlm_write_request *kb,
 static void compat_output(struct dlm_lock_result *res,
 			  struct dlm_lock_result32 *res32)
 {
-	res32->length = res->length - (sizeof(struct dlm_lock_result) -
-				       sizeof(struct dlm_lock_result32));
 	res32->user_astaddr = (__u32)(long)res->user_astaddr;
 	res32->user_astparam = (__u32)(long)res->user_astparam;
 	res32->user_lksb = (__u32)(long)res->user_lksb;
-- 
1.5.1.2



