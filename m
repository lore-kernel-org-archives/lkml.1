Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYLDRWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYLDRWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYLDRVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:21:55 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:10166 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYLDRVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:21:54 -0500
X-BigFish: VPS-1(zba6iz4015Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBD482-04-XU6-01
Date: Thu, 4 Dec 2008 18:21:42 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCHSETS] KVM device passthrough support with AMD IOMMU
Message-ID: <20081204172142.GH12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Dec 2008 17:21:42.0495 (UTC) FILETIME=[C67A1EF0:01C95634]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the two patchsets posted as reply to this email implement KVM device
passthrough support for AMD IOMMU hardware.

The first patchset is version 3 of the generic iommu api patchset which
generalizes the VT-d functions exported to KVM into a common api where
the AMD IOMMU code can plug into.

The second patchset finally implements the KVM device passthrough
support in the AMD IOMMU code. Together with KVM-79 I successfully
passed an 10GBit network card into an KVM guest.

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

