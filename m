Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZGCWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZGCWCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZGCWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 18:02:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40745 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbZGCWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 18:02:34 -0400
Subject: [GIT PULL] Kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 03 Jul 2009 23:02:30 +0100
Message-Id: <1246658550.13969.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 22:02:32.0123 (UTC) FILETIME=[F6CC90B0:01C9FC29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the kmemleak branch? This is hopefully the last
set of kmemleak changes for 2.6.31 (there may be some false positive
annotations). It seems to be consistent on my x86 hardware now but with
a few leak reports which I need to look at.

Thanks.


The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
  Yinghai Lu (1):
        x86: add boundary check for 32bit res before expand e820 resource to alignment

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (6):
      kmemleak: Renice the scanning thread to +10
      kmemleak: Add more cond_resched() calls in the scanning thread
      kmemleak: Remove the reported leaks number limitation
      kmemleak: Do not acquire scan_mutex in kmemleak_open()
      kmemleak: Scan objects allocated during a scanning episode
      kmemleak: Trace the kmalloc_large* functions in slub

 include/linux/slub_def.h |    2 +
 mm/kmemleak.c            |  129 ++++++++++++++++++++++++++++------------------
 mm/slub.c                |   10 ++--
 3 files changed, 86 insertions(+), 55 deletions(-)

-- 
Catalin

