Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZIRUdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZIRUdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbZIRUdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:33:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62107 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbZIRUdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:33:25 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/6] Linker script cleanup patches for m32r
Date: Fri, 18 Sep 2009 16:32:43 -0400
Message-Id: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent on September 6
cleaning up the m32r architecture's linker scripts.  It differs from V1
in that I moved spi_stack_top and spu_stack_top to .init.data at
Hirokazu Takata's request.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (6):
  m32r: make PAGE_SIZE available to assembly.
  m32r: Define THREAD_SIZE only once.
  m32r: Move GET_THREAD_INFO definition out of asm/thread_info.h.
  m32r: Remove unused .altinstructions and .exit.* code from linker
    script.
  m32r: Move the spi_stack_top and spu_stack_top into .init.data
    section.
  m32r: Cleanup linker script using new linker script macros.

 arch/m32r/include/asm/page.h        |    4 +-
 arch/m32r/include/asm/processor.h   |    2 -
 arch/m32r/include/asm/thread_info.h |   15 +------
 arch/m32r/kernel/entry.S            |    7 +++
 arch/m32r/kernel/head.S             |    4 +-
 arch/m32r/kernel/vmlinux.lds.S      |   78 ++++-------------------------------
 6 files changed, 23 insertions(+), 87 deletions(-)

