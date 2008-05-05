Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYEEMdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYEEMdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYEEMcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:32:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:33523 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYEEMcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:32:51 -0400
Message-ID: <481EFE69.20308@windriver.com>
Date: Mon, 05 May 2008 07:32:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kgdb fixes for 2.6.26
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2008 12:32:42.0275 (UTC) FILETIME=[1CE9C730:01C8AEAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for_linus branch at:

 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
for_linus

These are the fixes since the initial kgdb merge.

Thanks,
Jason.

---
Harvey Harrison (2):
      kgdb: trivial sparse fixes in kgdb test-suite
      kgdb: fix signedness mixmatches, add statics, add declaration to
header

Jan Engelhardt (1):
      kgdb: kconfig fix xconfig/menuconfig element

Jason Wessel (1):
      kgdb: 1000 loops for the single step test in kgdbts

grzegorz.chwesewicz@chilan.com (1):
      kgdb: minor documentation fixes

 Documentation/DocBook/kgdb.tmpl |    8 +++--
 drivers/misc/kgdbts.c           |   75
++++++++++++++++++++++----------------
 include/linux/kgdb.h            |    4 ++-
 kernel/kgdb.c                   |    8 ++--
 lib/Kconfig.kgdb                |   16 +++++----
 5 files changed, 64 insertions(+), 47 deletions(-)

