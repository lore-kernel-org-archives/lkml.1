Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXIVSZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXIVSZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXIVSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:25:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:57468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXIVSZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:25:32 -0400
Date: Sat, 22 Sep 2007 20:25:31 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add extended crashkernel syntax to kernel-parameters.txt
Message-ID: <20070922182530.GA4765@suse.de>
Mail-Followup-To: akpm@linux-foundation.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the documentation for the extended crashkernel syntax into
Documentation/kernel-parameters.txt.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -498,6 +498,13 @@ and is between 256 and 4096 characters. 
 			[KNL] Reserve a chunk of physical memory to
 			hold a kernel to switch to with kexec on panic.
 
+	crashkernel=range1:size1[,range2:size2,...][@offset]
+			[KNL] Same as above, but depends on the memory
+			in the running system. The syntax of range is
+			start-[end] where start and end are both
+			a memory unit (amount[KMG]). See also
+			Documentation/kdump/kdump.txt for a example.
+
 	cs4232=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>
 
