Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0CIWMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:12:43 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:44297 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0CIWMg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 9 Mar 2010 17:12:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, alex.williamson@hp.com,
       dwmw2@infradead.org
Subject: swiotlb: minor fixes for 2.6.35
Date: Tue,  9 Mar 2010 16:54:18 -0500
Message-Id: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B96C7AB.00A9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached are four simple patches that clean up the SWIOTLB library a bit.
There aren't that important, but I figured since I am doing some other work
in that layer I might as well fix some things that looked out of place.

Oh, and the first one is backwards compatible with the "old" syntax of
changing SWIOTLB IOMMU allocation amount ("swiotlb=1024,force").

Please take a moment to review them.

Konrad Rzeszutek Wilk (4):
      swiotlb: fix: Update 'setup_io_tlb_npages' to accept both arguments in either order.
      swiotlb: Normalize the swiotlb_init_* function's naming syntax.
      swiotlb: Make printk's use same prefix and include dev_err when possible.
      swiotlb: Fix checkpatch warnings.

---

 Documentation/x86/x86_64/boot-options.txt |    4 +-
 lib/swiotlb.c                             |   84 +++++++++++++++--------------
 2 files changed, 46 insertions(+), 42 deletions(-)

