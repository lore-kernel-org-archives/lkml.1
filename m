Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYLIOTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYLIOTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYLIOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:36 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52502 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYLIOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:27 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBM4Z6-03-KKN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCH 0/21] AMD IOMMU support for KVM device assignment
Date: Tue, 9 Dec 2008 15:15:57 +0100
Message-ID: <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081209141143.GW12816@amd.com>
References: <20081209141143.GW12816@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0669 (UTC) FILETIME=[B439B9D0:01C95A08]
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
 arch/x86/kernel/amd_iommu.c            |  448 +++++++++++++++++++++++++++++---
 2 files changed, 416 insertions(+), 47 deletions(-)



