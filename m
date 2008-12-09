Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYLIOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYLIOMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYLIOMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:12:37 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:30279 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYLIOMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:12:36 -0500
X-BigFish: VPS-1(zba6iz4015Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4RK-04-A6Z-01
Date: Tue, 9 Dec 2008 15:11:43 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Message-ID: <20081209141143.GW12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Dec 2008 14:11:44.0203 (UTC) FILETIME=[10A189B0:01C95A08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the two patchsets posted as reply to this email implement KVM device
passthrough support for AMD IOMMU hardware. The changes to the previous
posts are descibed below

The first patchset is version 4 of the generic iommu api patchset which
generalizes the VT-d functions exported to KVM into a common api where
the AMD IOMMU code can plug into. In this version the patchset was
rebased to the latest post of Han Weidong's patches.

The second patchset finally implements the KVM device passthrough
support in the AMD IOMMU code. Together with KVM-79 I successfully
passed an 10GBit network card into an KVM guest. In this version the
patchset was changed to remove any device before a protection domain is
freed instead of printing a BUG. Also the patchset was rebased to the
updated IOMMU-API patches.

These two patchsets apply in order in top of the latest post of
Han Weidong's Multiple device assignement support patches. Anybody who
wants to try this out can pull the whole stuff from

git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git kvm-amd-iommu

Please give these patches a good review.

Thanks,

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

