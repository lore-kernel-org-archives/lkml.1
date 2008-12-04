Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYLDRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYLDRg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYLDRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:18 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14597 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbYLDRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:10 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBD4P5-04-YDH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCH 0/19] AMD IOMMU support for KVM device assignment
Date: Thu, 4 Dec 2008 18:31:37 +0100
Message-ID: <1228411916-22668-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:56.0884 (UTC) FILETIME=[34AE7140:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements KVM device assignment support in the AMD IOMMU
driver. It uses the generic interface from the iommu-api patchset and
was successfully tested using an 10GBit network card passed through to
an KVM guest.

diffstat:

 arch/x86/include/asm/amd_iommu_types.h |   15 +-
 arch/x86/kernel/amd_iommu.c            |  426 ++++++++++++++++++++++++++++----
 2 files changed, 393 insertions(+), 48 deletions(-)



