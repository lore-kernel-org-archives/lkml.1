Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0BTJl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:41:26 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50322 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab0BTJlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:41:24 -0500
Date: Sat, 20 Feb 2010 09:41:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Document /sys/devices/system/node/nodeX
Message-ID: <20100220094109.GJ1445@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bare description of what /sys/devices/system/node/nodeX is. Others
will follow in time but right now, none of that tree is documented. The
existence of this file might at least encourage people to document new entries.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 Documentation/ABI/stable/sysfs-devices-node |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-node

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
new file mode 100644
index 0000000..49b82ca
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -0,0 +1,7 @@
+What:		/sys/devices/system/node/nodeX
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		When CONFIG_NUMA is enabled, this is a directory containing
+		information on node X such as what CPUs are local to the
+		node.
-- 
1.6.5

