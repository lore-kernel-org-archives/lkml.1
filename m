Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYHTQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYHTQlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYHTQkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:40:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42540 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYHTQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:40:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: robert.richter@amd.com, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] oprofile: document undocumented oprofile.p4force argument
Date: Wed, 20 Aug 2008 18:40:33 +0200
Message-Id: <1219250433-25516-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219250433-25516-4-git-send-email-andi@firstfloor.org>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
 <1219250433-25516-2-git-send-email-andi@firstfloor.org>
 <1219250433-25516-3-git-send-email-andi@firstfloor.org>
 <1219250433-25516-4-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It's actually useless now, but document it anyways.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 10c8b1b..5e77e1a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1491,6 +1491,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			in oprofile on Intel CPUs.  The kernel selects the
 			correct default on its own.
 
+	oprofile.p4force=1 [X86]
+			On Intel NetBurst CPUs assume new models are compatible
+			to older ones. This might allow oprofile to be used when
+			the kernel doesn't know the CPU, but is slightly dangerous.
+			Should be obsolete by now.
+
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
 			See also Documentation/scsi/st.txt.
-- 
1.5.6

