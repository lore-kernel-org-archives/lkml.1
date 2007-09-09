Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXIIIHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXIIIHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 04:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXIIIG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 04:06:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:34639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbXIIIGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 04:06:22 -0400
Message-Id: <20070909080620.899626206@strauss.suse.de>
References: <20070909080620.009772613@strauss.suse.de>
User-Agent: quilt/0.46-57
Date: Sun, 09 Sep 2007 10:06:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/3] Add reset_devices to the recommended parameters
Content-Disposition: inline; filename=crashkernel-reset_devices
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the "reset_devices" option (that's used only by one device
driver for now) to the recommended list of command line parameters for kdump.

Meaning (Documentation/kernel-parameters.txt):
    reset_devices   [KNL] Force drivers to reset the underlying device
                    during initialization.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 Documentation/kdump/kdump.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -292,10 +292,10 @@ Following are the arch specific command 
 loading dump-capture kernel.
 
 For i386, x86_64 and ia64:
-	"1 irqpoll maxcpus=1"
+	"1 irqpoll maxcpus=1 reset_devices"
 
 For ppc64:
-	"1 maxcpus=1 noirqdistrib"
+	"1 maxcpus=1 noirqdistrib reset_devices"
 
 
 Notes on loading the dump-capture kernel:

-- 
