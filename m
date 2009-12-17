Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbZLQBln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbZLQBln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763610AbZLQBUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:14 -0500
Received: from kroah.org ([198.145.64.141]:47852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763606AbZLQBUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:01 2009
Message-Id: <20091217011601.657714019@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [29/90] x86/amd-iommu: un__init iommu_setup_msi
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 9f800de38b05d84809e89f16671d636a140eede7 upstream.

This function may be called on the resume path and can not
be dropped after booting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -915,7 +915,7 @@ static int __init init_iommu_all(struct 
  *
  ****************************************************************************/
 
-static int __init iommu_setup_msi(struct amd_iommu *iommu)
+static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 


