Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbYEVVSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbYEVVSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbYEVVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:18:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763304AbYEVVSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:18:13 -0400
Date: Thu, 22 May 2008 17:17:23 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] debug printk infrastructure -dynamic printk docs
Message-ID: <20080522211723.GE28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
-- 
1.5.4.5


