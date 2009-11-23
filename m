Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZKWNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZKWNt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZKWNtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:49:55 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33389
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751649AbZKWNtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:49:55 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTKEF1-01-0RZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: [git pull] AMD IOMMU updates for 2.6.32-rc
Date: Mon, 23 Nov 2009 14:49:44 +0100
Message-ID: <1258984186-4328-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
X-OriginalArrivalTime: 23 Nov 2009 13:49:50.0114 (UTC) FILETIME=[D38A3820:01CA6C43]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,


The following changes since commit 123bf0e2eddcda36a33bdfc87aa1fb07229f07b5:
  Ingo Molnar (1):
        x86: gart: Clean up the code a bit

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Joerg Roedel (2):
      x86/amd-iommu: un__init iommu_setup_msi
      x86/amd-iommu: attach devices to pre-allocated domains early

 arch/x86/kernel/amd_iommu.c      |    8 ++++++--
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

The first patch fixes a possible crash on resume if the compiler does not
inline the iommu_setup_msi function. The second patch fixes possible I/O page
faults on boot if BIOS is still using a device before the Linux driver takes it
over. Please pull.

	Joerg


