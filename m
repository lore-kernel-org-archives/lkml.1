Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZITRg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZITRg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZITRgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:36:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53007 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996AbZITRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:36:24 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@sunplusct.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 0/3] Linker script cleanup patches for score
Date: Sun, 20 Sep 2009 13:32:56 -0400
Message-Id: <1253467979-14110-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the linker script for the score
architecture to use the new linker script macros merged in 2.6.31.
I'd love to see these included in 2.6.32 (Sorry that these are coming
so late -- I had missed the score architecture being merged.)

While the changes are pretty straightforward, note that these patches
haven't been tested at all (I don't have an appropriate cross
compiler).

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (3):
  score: Make PAGE_SIZE available to assembly.
  Make THREAD_SIZE available to assembly files.
  score: Cleanup linker script using new macros.

 arch/score/include/asm/page.h        |    3 +-
 arch/score/include/asm/thread_info.h |   15 ++++---
 arch/score/kernel/vmlinux.lds.S      |   75 +++------------------------------
 3 files changed, 18 insertions(+), 75 deletions(-)

