Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZAZVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZAZVEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZAZVDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:03:49 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:47266 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZAZVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:03:49 -0500
Date: Mon, 26 Jan 2009 13:03:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>
Subject: [PATCH 3/3 for mainline] docs: fix emacs indenting howto filename
 expansion
Message-Id: <20090126130332.1dd2a967.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.497E252F.0320:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Subject: fix emacs indenting howto filename expansion

I don't think emacs understands tilde expansion, so use
"expand-file-name" to do that.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

---
 Documentation/CodingStyle |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090126.orig/Documentation/CodingStyle
+++ linux-next-20090126/Documentation/CodingStyle
@@ -498,7 +498,8 @@ values.  To do the latter, you can stick
             (let ((filename (buffer-file-name)))
               ;; Enable kernel mode for the appropriate files
               (when (and filename
-                         (string-match "~/src/linux-trees" filename))
+                         (string-match (expand-file-name "~/src/linux-trees")
+                                       filename))
                 (setq indent-tabs-mode t)
                 (c-set-style "linux-tabs-only")))))
 
