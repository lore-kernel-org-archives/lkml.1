Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZGXQMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZGXQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZGXQME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:04 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51149 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbZGXQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:04 -0400
Subject: [PATCH 0/8] Kmemleak patches for 2.6.32
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:01 +0100
Message-ID: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:02.0299 (UTC) FILETIME=[7AB8D4B0:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are kmemleak related patches I plan to submit for mainline
inclusion during the upcoming merging window. I'll push them to the
linux-next tree once any comments received are implemented.

Thanks.


Catalin Marinas (7):
      kmemleak: Dump object information on request
      kmemleak: Allow rescheduling during an object scanning
      kmemleak: Mark the early log buffer as __initdata
      kmemleak: Save the stack trace for early allocations
      kmemleak: Do not report alloc_bootmem blocks as leaks
      kmemleak: Inform kmemleak about kernel stack allocation
      kmemleak: Always scan the task stacks

Sergey Senozhatsky (1):
      kmemleak: Printing of the objects hex dump


 Documentation/kmemleak.txt         |   12 +-
 arch/x86/include/asm/thread_info.h |    7 +
 arch/x86/kernel/process.c          |    1 
 include/linux/kmemleak.h           |   18 ++-
 kernel/fork.c                      |    7 +
 mm/bootmem.c                       |    6 +
 mm/kmemleak.c                      |  195 +++++++++++++++++++++++++++---------
 7 files changed, 178 insertions(+), 68 deletions(-)

-- 
Catalin
