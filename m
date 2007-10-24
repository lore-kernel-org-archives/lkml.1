Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXJXWQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXJXWQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXJXWOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:14:03 -0400
Received: from xenotime.net ([66.160.160.81]:52018 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753997AbXJXWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:13:57 -0400
Date: Wed, 24 Oct 2007 15:08:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes@sipsolutions.net>,
       sam@ravnborg.org
Subject: [PATCH 2/6] kernel-doc: init kernel version
Message-ID: <1193263728737@xenotime.net>
In-Reply-To: <11932637282902@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

The kernel-doc script triggers a perl warning when invoked
without KERNELVERSION in the environment, rather make it use
the string "unknown kernel version" instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-git19.orig/scripts/kernel-doc
+++ linux-2.6.23-git19/scripts/kernel-doc
@@ -334,7 +334,7 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 
 # get kernel version from env
 sub get_kernel_version() {
-    my $version;
+    my $version = 'unknown kernel version';
 
     if (defined($ENV{'KERNELVERSION'})) {
 	$version = $ENV{'KERNELVERSION'};


-- 

