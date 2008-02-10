Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYBJXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYBJXsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYBJXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:48:43 -0500
Received: from mail.fieldses.org ([66.93.2.214]:42161 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYBJXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:48:42 -0500
Date: Sun, 10 Feb 2008 18:48:41 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: prune redundant SubmitChecklist items
Message-ID: <20080210234841.GC20829@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Kernel style is mentioned twice, and the git apply trick is a bit
redundant given the checkpatch.pl recommendation (which also checks for
bad whitespace).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 Documentation/SubmitChecklist |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index 34e06d2..da10e07 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -20,7 +20,11 @@ kernel patches.
 4: ppc64 is a good architecture for cross-compilation checking because it
    tends to use `unsigned long' for 64-bit quantities.
 
-5: Matches kernel coding style(!)
+5: Check your patch for general style as detailed in
+   Documentation/CodingStyle.  Check for trivial violations with the
+   patch style checker prior to submission (scripts/checkpatch.pl).
+   You should be able to justify all violations that remain in
+   your patch.
 
 6: Any new or modified CONFIG options don't muck up the config menu.
 
@@ -79,13 +83,3 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
-
-24: Avoid whitespace damage such as indenting with spaces or whitespace
-    at the end of lines.  You can test this by feeding the patch to
-    "git apply --check --whitespace=error-all"
-
-25: Check your patch for general style as detailed in
-    Documentation/CodingStyle.  Check for trivial violations with the
-    patch style checker prior to submission (scripts/checkpatch.pl).
-    You should be able to justify all violations that remain in
-    your patch.
-- 
1.5.4.rc2.60.gb2e62

