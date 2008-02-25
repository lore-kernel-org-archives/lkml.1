Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbYBYAZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbYBYAZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYBYAZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:32 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:6055 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYBYAZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EU7VUD8SggtxrxthVUPyTb5VU/jXAfqBd4HW/7SZ7pijLn8rYOLGIiX+6KV0fuRvURsd+xGPeKdfrjkT5gtxTszUo48l0r6TMsZ1AvPCjDSLH7G9LjU6GRuUAqEY31HKADEypXHsL1ZT78EGHweKTqQjez/bDZLzAAF6DyKSeRw=
Subject: [PATCH 1/6] markers: make marker_debug static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:34 -0800
Message-Id: <1203899134.1767.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc2 and -rc3
kernel/marker.c:31:11: warning: symbol 'marker_debug' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/marker.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/marker.c b/kernel/marker.c
index 50effc0..dc2eb12 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -28,7 +28,7 @@ extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-const int marker_debug;
+static const int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
-- 
1.5.4.2.200.g99e75


