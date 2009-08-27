Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbZH0RDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbZH0RDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZH0RDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:03:44 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34803 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZH0RDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:03:43 -0400
Subject: [PATCH 0/2] kmemleak: x86-related patches
To: x86@kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 27 Aug 2009 18:02:47 +0100
Message-ID: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2009 17:02:47.0895 (UTC) FILETIME=[34156670:01CA2738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I plan to submit these two x86-related patches for 2.6.32. Are the x86
people OK with them (so that I can add the relevant ack)?

Thanks.


Catalin Marinas (2):
      kmemleak: Inform kmemleak about kernel stack allocation
      kmemleak: Ignore the aperture memory hole on x86_64


 Documentation/kmemleak.txt         |   11 +++++------
 arch/x86/include/asm/thread_info.h |    7 ++++++-
 arch/x86/kernel/aperture_64.c      |    6 ++++++
 arch/x86/kernel/pci-dma.c          |    6 ++++++
 arch/x86/kernel/process.c          |    2 ++
 kernel/fork.c                      |    7 ++++++-
 mm/kmemleak.c                      |   22 ----------------------
 7 files changed, 31 insertions(+), 30 deletions(-)

-- 
Catalin
