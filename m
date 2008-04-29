Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYD2SpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYD2SpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYD2SpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:45:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbYD2SpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:45:04 -0400
Date: Tue, 29 Apr 2008 14:44:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/3] dynamic_printk: docs update
Message-ID: <20080429184431.GD8717@redhat.com>
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
index bf6303e..d9a1245 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1580,6 +1580,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	dynamic_printk
+			Enables pr_debug()/dev_dbg() calls if 
+			CONFIG_PRINK_DYNAMIC has been enabled. These can also 
+			be switched on/off via <debugfs>/dynamic_printk/modules
+
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
