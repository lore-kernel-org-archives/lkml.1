Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYIEJEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYIEJEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYIEJD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:03:29 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57603 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYIEJD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:03:26 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] fix alloc_coherent allocation issues (tip/x86/iommu)
Date: Fri,  5 Sep 2008 17:58:46 +0900
Message-Id: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset restores some of the current alloc_coherent behaviors
that Joerg's x86 patchset (in tip/x86/iommu) changes.

The first patch uses __GFP_DMA for NULL device argument (fallback_dev)
with pci-nommu. It's a hack for ISA (and some old code) so we need
DMA_ZONE.

The second patch uses __GFP_NORETRY in the case of GFP_DMA.

The third patch is a minor cleanup.


I'll send patchset for the rest of alloc_coherent issues this weekend.


