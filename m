Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbZIPQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbZIPQmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbZIPQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:42:44 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39841 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759823AbZIPQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:42:40 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-kernel@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/3] Linker script cleanup patches for alpha
Date: Wed, 16 Sep 2009 12:38:36 -0400
Message-Id: <1253119119-18956-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the alpha architecture's linker scripts.  There are some
fixes based on comments from Richard Henderson; it has also been
rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

Geoffrey Thomas (1):
  alpha: Clean up linker script using new linker script macros.

Tim Abbott (2):
  alpha: use .data.init_task instead of .data.init_thread.
  Optimize the ordering of sections in RW_DATA_SECTION.

 arch/alpha/kernel/init_task.c     |    5 +-
 arch/alpha/kernel/vmlinux.lds.S   |   95 ++++---------------------------------
 include/asm-generic/vmlinux.lds.h |    4 +-
 3 files changed, 14 insertions(+), 90 deletions(-)

