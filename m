Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXECUil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXECUil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161162AbXECUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:38:41 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:38388 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161309AbXECUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:38:37 -0400
X-IronPort-AV: i="4.14,487,1170662400"; 
   d="scan'208"; a="373264028:sNHT48910744630"
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add info about whitespace to SubmitChecklist
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 May 2007 13:38:17 -0700
Message-ID: <ada1whxd4na.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 May 2007 20:38:17.0991 (UTC) FILETIME=[FB233970:01C78DC2]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index bd23dc0..6491b2c 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -80,3 +80,7 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
+
+24: Avoid whitespace damage such as indenting with spaces or whitespace
+    at the end of lines.  You can test this by feeding the patch to
+    "git apply --check --whitespace=error-all"
