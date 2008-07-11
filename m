Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYGKPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYGKPQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYGKPPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:01 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64726 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbYGKPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:14:59 -0400
X-BigFish: VPS-1(z5edJz3117Kzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL08-04-EO9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com
Subject: [PATCH 0/16] AMD IOMMU updates
Date: Fri, 11 Jul 2008 17:14:19 +0200
Message-ID: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 11 Jul 2008 15:14:35.0899 (UTC) FILETIME=[D45C6CB0:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series contain updates to the AMD IOMMU driver currently in
tip/master. The updates are mostly added comments and fixes for objections by
Andrew Morton. Some of Andrews objections are not yet fixed (mostly the ones
where I have to touch other subsytems too). The patch series also contains a
small bugfix in device table allocation.

Regards,

Joerg

diffstat (as I said, most of this are comments):

 arch/x86/kernel/amd_iommu.c       |  229 ++++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c  |  328 ++++++++++++++++++++++++++++---------
 include/asm-x86/amd_iommu_types.h |  114 ++++++++++++-
 3 files changed, 577 insertions(+), 94 deletions(-)



