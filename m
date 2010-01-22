Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017Ab0AVRTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0AVRTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148Ab0AVRTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:19:32 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16999 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0AVRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:19:29 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zzab9bh936eMzz1202hzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KWNS2H-01-CVJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Thiago Farina <tfransosi@gmail.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] lib/dma-debug.c: mark file-local struct symbol static.
Date: Fri, 22 Jan 2010 18:18:13 +0100
Message-ID: <1264180693-27197-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0876 (UTC) FILETIME=[E2571040:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiago Farina <tfransosi@gmail.com>

warning: symbol 'filter_fops' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 7399744..e039958 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -587,7 +587,7 @@ out_unlock:
 	return count;
 }
 
-const struct file_operations filter_fops = {
+static const struct file_operations filter_fops = {
 	.read  = filter_read,
 	.write = filter_write,
 };
-- 
1.6.6


