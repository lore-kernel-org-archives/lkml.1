Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYLPSVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYLPSVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLPSVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:21:24 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:1087 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYLPSVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:21:24 -0500
X-BigFish: VPS-12(z21eWzzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBZEZ6-03-RO0-01
Date: Tue, 16 Dec 2008 19:21:10 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU fix for 2.6.28-rc8
Message-ID: <20081216182110.GQ3407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 16 Dec 2008 18:21:10.0630 (UTC) FILETIME=[12355060:01C95FAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,


The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (1):
      AMD IOMMU: allocate rlookup_table with __GFP_ZERO

 arch/x86/kernel/amd_iommu_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Its an important fix for a bug which triggered a panic at boot in
long-duration reboot tests. Please pull.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

