Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYKFOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYKFOQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYKFOQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:16:10 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:16238 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKFOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:16:09 -0500
X-BigFish: VPS-12(z21eWzzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K9X0YI-04-PS8-01
Date: Thu, 6 Nov 2008 15:15:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU fixes for 2.6.28
Message-ID: <20081106141555.GD22503@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Nov 2008 14:15:56.0296 (UTC) FILETIME=[2F422080:01C9401A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 1e19b16a30c34c042f1eaa23db4c99bfad1dac0e:
  Thomas Gleixner (1):
        AMD IOMMU: use iommu_device_max_index, fix

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (2):
      AMD IOMMU: fix detection of NP capable IOMMUs
      AMD IOMMU: fix lazy IO/TLB flushing in unmap path

 arch/x86/kernel/amd_iommu.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

This are 2 important bugfixes which fix lazy IO/TLB flushing with the
driver. Please pull.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

