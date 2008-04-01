Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYDATvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYDATvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYDATvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:51:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbYDATvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:51:43 -0400
Date: Tue, 1 Apr 2008 15:51:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 3/3] dynamic printk - docs
Message-ID: <20080401195138.GE12029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-add documentation about printk_dynamic in kernel-parameters.txt

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 Documentation/kernel-parameters.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cf38689..e3c1489 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1494,6 +1494,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	printk_dynamic
+			Enables pr_debug()/dev_dbg() calls if 
+			CONFIG_PRINK_DYNAMIC has been enabled. These can also 
+			be switched on/off via <debugfs>/dynamic_printk/files
+
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
