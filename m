Return-Path: <linux-kernel-owner+w=401wt.eu-S1161288AbXBZWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161288AbXBZWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161287AbXBZWZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:25:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11093 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161288AbXBZWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:25:25 -0500
Date: Mon, 26 Feb 2007 14:21:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] add -mm testing in SubmitChecklist
Message-Id: <20070226142156.1372f5ed.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add -mm testing to SubmitChecklist.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmitChecklist |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2621-rc1.orig/Documentation/SubmitChecklist
+++ linux-2621-rc1/Documentation/SubmitChecklist
@@ -76,3 +76,7 @@ kernel patches.
 22: Newly-added code has been compiled with `gcc -W'.  This will generate
     lots of noise, but is good for finding bugs like "warning: comparison
     between signed and unsigned".
+
+23: Tested after it has been merged into the -mm patchset to make sure
+    that it still works with all of the other queued patches and various
+    changes in the VM, VFS, and other subsystems.
