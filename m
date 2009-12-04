Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZLDKCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZLDKCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZLDKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:02:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57590 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbZLDKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:02:53 -0500
Subject: [GIT PULL] Kmemleak patches
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 04 Dec 2009 10:02:54 +0000
Message-Id: <1259920974.12495.11.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2009 10:02:55.0449 (UTC) FILETIME=[F31C7490:01CA74C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please merge the kmemleak branch below? It contains some
improvements to kmemleak (including reduced rate of false positives).
Thanks.

The following changes since commit 012abeea669ea49636cf952d13298bb68654146a:
  Linus Torvalds (1):
        Linux 2.6.32-rc5

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (6):
      kmemleak: Do not use off-slab management with SLAB_NOLEAKTRACE
      kmemleak: Simplify the kmemleak_scan_area() function prototype
      kmemleak: Scan the _ftrace_events section in modules
      kmemleak: Release the object lock before calling put_object()
      kmemleak: Show the age of an unreferenced object
      kmemleak: Reduce the false positives by checking for modified objects

Randy Dunlap (1):
      kmemleak: fix kconfig for crc32 build error

 include/linux/kmemleak.h |    6 +-
 kernel/module.c          |   13 ++-
 lib/Kconfig.debug        |    1 +
 mm/kmemleak.c            |  188 +++++++++++++++++++++++++---------------------
 mm/slab.c                |   10 ++-
 5 files changed, 118 insertions(+), 100 deletions(-)

-- 
Catalin

