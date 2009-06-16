Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZFPIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZFPIwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZFPIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:52:24 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:44367
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751422AbZFPIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:52:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLBPZ2-02-3FR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull][PATCH 0/2] dma-debug fixes
Date: Tue, 16 Jun 2009 10:52:08 +0200
Message-ID: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 16 Jun 2009 08:52:14.0983 (UTC) FILETIME=[BEF57170:01C9EE5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 92db1e6af747faa129e236d68386af26a0efc12b:
  Ingo Molnar (1):
        Merge branch 'amd-iommu/fixes' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes

Joerg Roedel (2):
      dma-debug: check for sg_call_ents in best-fit algorithm too
      dma-debug: be more careful when building reference entries

 lib/dma-debug.c |  149 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 98 insertions(+), 51 deletions(-)

These patches fix some false positive warnings which occured also with
the change to the best-fit search in hash_bucket_find(). Please pull.

	Joerg


