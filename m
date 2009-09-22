Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZIVQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZIVQ5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZIVQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:57:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48915 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbZIVQ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:57:27 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/2] Linker script cleanup patches for m68knommu
Date: Tue, 22 Sep 2009 12:56:53 -0400
Message-Id: <1253638615-27009-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This patch series is an updated version of the patch I sent you on
September 6 cleaning up the m68knommu architecture's linker scripts.
Since the original patches had a few bugs, I figured I'd send you a
clean copy of state as of when I last hear from you two weeks ago.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

Tim Abbott (2):
  m68knommu: Make THREAD_SIZE available to assembly files.
  m68knommu: Clean up linker script using new linker script macros.

 arch/m68k/include/asm/thread_info_no.h |    4 +-
 arch/m68knommu/kernel/vmlinux.lds.S    |   41 ++++++++-----------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

