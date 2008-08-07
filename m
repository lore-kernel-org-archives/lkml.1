Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYHGNHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYHGNHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYHGNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:07:04 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1253 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYHGNHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:07:01 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j)
X-WSS-ID: 0K58F3C-04-DHJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: akpm@linux-foundation.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] make swiotlb prototypes generic
Date: Thu, 7 Aug 2008 15:06:46 +0200
Message-ID: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 07 Aug 2008 13:06:50.0381 (UTC) FILETIME=[748273D0:01C8F88E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small series of patches introduce a generic header file for the software
IO/TLB implementation in lib/swiotlb.c. Currently each architecture using this
code defines the prototypes itself. The prototypes are moved to
include/linux/swiotlb.h and this file is included in architecture specific code
for X86 and IA64. The changes are compile tested for both architectures.

Joerg

git diff --stat linus/master:

 arch/ia64/hp/common/hwsw_iommu.c |    9 +----
 arch/ia64/include/asm/machvec.h  |   22 +----------
 include/asm-x86/swiotlb.h        |   40 +------------------
 include/linux/swiotlb.h          |   83 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 68 deletions(-)



