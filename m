Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbZA3A3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbZA3A3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZA3A3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:29:16 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47372 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbZA3A3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:29:14 -0500
Date: Thu, 29 Jan 2009 16:28:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
       Dan Carpenter <error27@gmail.com>
Subject: [PATCH 3/4] Documentation: fix emacs indenting howto filename
 expansion
Message-Id: <20090129162828.0292ab00.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.498249AE.01F2:SCFSTAT928724,ss=1,fgs=0
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
 
