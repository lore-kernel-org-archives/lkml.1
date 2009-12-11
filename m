Return-Path: <linux-kernel-owner+w=401wt.eu-S933500AbZLKP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbZLKP6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbZLKP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:58:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36833 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932334AbZLKP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:58:36 -0500
Subject: [GIT PULL] Kmemleak patches
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Dec 2009 10:02:55.0449 (UTC)
	FILETIME=[F31C7490:01CA74C8]
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 11 Dec 2009 15:57:49 +0000
Message-Id: <1260547070.25477.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

(sorry for the re-post but just in case you missed the first e-mail)

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

