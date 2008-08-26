Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYHZWOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYHZWOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYHZWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:14:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49222 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085AbYHZWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:14:05 -0400
Date: Tue, 26 Aug 2008 17:14:02 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Greg KH <greg@kroah.com>
Cc: Russ Anderson <rja@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH] sysfs: Document files in /sys/firmware/sgi_uv/
Message-ID: <20080826221402.GB173430@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document files in /sys/firmware/sgi_uv/.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 Documentation/ABI/testing/sysfs-firmware-sgi_uv |   27 ++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: linux/Documentation/ABI/testing/sysfs-firmware-sgi_uv
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/Documentation/ABI/testing/sysfs-firmware-sgi_uv	2008-08-26 17:00:18.000000000 -0500
@@ -0,0 +1,27 @@
+What:		/sys/firmware/sgi_uv/
+Date:		August 2008
+Contact:	Russ Anderson <rja@sgi.com>
+Description:
+		The /sys/firmware/sgi_uv directory contains information
+		about the SGI UV platform.
+
+		Under that directory are a number of files:
+
+			partition_id
+			coherence_id
+
+		The partition_id entry contains the partition id.
+		SGI UV systems can be partitioned into multiple physical
+		machines, which each partition running a unique copy
+		of the operating system.  Each partition will have a unique
+		partition id.  To display the partition id, use the command:
+
+			cat /sys/firmware/sgi_uv/partition_id
+
+		The coherence_id entry contains the coherence id.
+		A partitioned SGI UV system can have one or more coherence
+		domain.  The coherence id indicates which coherence domain
+		this partition is in.  To display the coherence id, use the
+		command:
+
+			cat /sys/firmware/sgi_uv/coherence_id
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
