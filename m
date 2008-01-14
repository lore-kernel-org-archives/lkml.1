Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYANXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYANXQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYANXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:16:46 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33478 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYANXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:16:45 -0500
Date: Mon, 14 Jan 2008 15:14:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, zanussi@us.ibm.com
Subject: [PATCH] doc: use correct debugfs mountpoint
Message-Id: <20080114151443.dfe6844a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use the normal, expected mountpoint in the relay(fs) example
for debugfs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/relay.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7.orig/Documentation/filesystems/relay.txt
+++ linux-2.6.24-rc7/Documentation/filesystems/relay.txt
@@ -140,7 +140,7 @@ close()     decrements the channel buffe
 In order for a user application to make use of relay files, the
 host filesystem must be mounted.  For example,
 
-	mount -t debugfs debugfs /debug
+	mount -t debugfs debugfs /sys/kernel/debug
 
 NOTE:   the host filesystem doesn't need to be mounted for kernel
 	clients to create or use channels - it only needs to be
