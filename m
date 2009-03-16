Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZCPRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZCPRMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZCPRMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:12:08 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:23214
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754111AbZCPRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:12:07 -0400
X-BigFish: VPS1(zzzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KGLZH0-02-R4T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH 0/3] dma-debug: add additional checks
Date: Mon, 16 Mar 2009 18:05:27 +0100
Message-ID: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 16 Mar 2009 17:05:30.0509 (UTC) FILETIME=[694353D0:01C9A659]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small series of patches adds three additional checks to the dma-api
debugging code. The first one checks if dma mappings are requested for
kernel text or rodata segments.
The second check added makes noise if a device is unbound from its
driver and there are still pending dma allocations we are aware of.

Joerg

diffstat:

 arch/x86/kernel/pci-dma.c |    4 ++
 include/linux/dma-debug.h |    7 ++++
 lib/dma-debug.c           |   81 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 1 deletions(-)



