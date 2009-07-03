Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZGCIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZGCIdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZGCIcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:32:46 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:55425 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbZGCIcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:32:43 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z21eWz4015Lzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM76EA-02-349-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [git pull] dma-debug fixes for 2.6.31-rc1
Date: Fri, 3 Jul 2009 10:32:02 +0200
Message-ID: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 03 Jul 2009 08:32:08.0238 (UTC) FILETIME=[C0B484E0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
  Yinghai Lu (1):
        x86: add boundary check for 32bit res before expand e820 resource to alignment

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes

Ingo Molnar (1):
      dma-debug: Put all hash-chain locks into the same lock class

Joerg Roedel (1):
      dma-debug: fix off-by-one error in overlap function

 lib/dma-debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

These patches make dma-debug work better with lockdep enabled and fix a corner
case in the overlap function were one region ends exactly where the other one
begins. Please pull.

Thanks,

	Joerg


