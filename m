Return-Path: <linux-kernel-owner+w=401wt.eu-S1765024AbYCSVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765024AbYCSVO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761929AbYCST7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36149 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761894AbYCST7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:31 -0400
Date: Wed, 19 Mar 2008 15:58:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org
Subject: iommu: it could use some documentation
Message-ID: <20080319145811.GA27113@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix coding style in pci-dma_64.c and add stubs for documentation. I
hope someone fills the rest, I understand maybe off and soft...

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 3ab83390752b5e71c6f04230dcd25c7789bb5099
tree 295a3567278a216785cd4e32dc3bcae2c5aad572
parent d5ac3c822e1036165b92d62e464be1e61c12d757
author Pavel <pavel@amd.ucw.cz> Wed, 19 Mar 2008 15:57:03 +0100
committer Pavel <pavel@amd.ucw.cz> Wed, 19 Mar 2008 15:57:03 +0100

 Documentation/kernel-parameters.txt |   13 +++++++++++++
 arch/x86/kernel/pci-dma_64.c        |   20 ++++++++++----------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 467034c..d803f70 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -811,6 +811,19 @@ and is between 256 and 4096 characters. 
 
 	inttest=	[IA64]
 
+	iommu=		[x86]
+		off
+		force
+		noforce
+		biomerge
+		panic
+		nopanic
+		merge
+		nomerge
+		forcesac
+		soft
+
+
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
 		off
 			Disable intel iommu driver.
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index a82473d..a9d3f54 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -237,32 +237,32 @@ static __init int iommu_setup(char *p)
 		return -EINVAL;
 
 	while (*p) {
-		if (!strncmp(p,"off",3))
+		if (!strncmp(p, "off", 3))
 			no_iommu = 1;
 		/* gart_parse_options has more force support */
-		if (!strncmp(p,"force",5))
+		if (!strncmp(p, "force", 5))
 			force_iommu = 1;
-		if (!strncmp(p,"noforce",7)) {
+		if (!strncmp(p, "noforce", 7)) {
 			iommu_merge = 0;
 			force_iommu = 0;
 		}
 
-		if (!strncmp(p, "biomerge",8)) {
+		if (!strncmp(p, "biomerge", 8)) {
 			iommu_bio_merge = 4096;
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-		if (!strncmp(p, "panic",5))
+		if (!strncmp(p, "panic", 5))
 			panic_on_overflow = 1;
-		if (!strncmp(p, "nopanic",7))
+		if (!strncmp(p, "nopanic", 7))
 			panic_on_overflow = 0;
-		if (!strncmp(p, "merge",5)) {
+		if (!strncmp(p, "merge", 5)) {
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-		if (!strncmp(p, "nomerge",7))
+		if (!strncmp(p, "nomerge", 7))
 			iommu_merge = 0;
-		if (!strncmp(p, "forcesac",8))
+		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
@@ -270,7 +270,7 @@ static __init int iommu_setup(char *p)
 			forbid_dac = -1;
 
 #ifdef CONFIG_SWIOTLB
-		if (!strncmp(p, "soft",4))
+		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;
 #endif
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
