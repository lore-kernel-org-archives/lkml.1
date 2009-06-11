Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZFKQ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZFKQ0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZFKQZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:25:53 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:60281 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbZFKQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:25:52 -0400
Subject: kmemleak: Pull request
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Jun 2009 17:25:27 +0100
Message-Id: <1244737527.13225.69.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2009 16:25:28.0483 (UTC) FILETIME=[3B7B7F30:01C9EAB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the kmemleak patches from the branch detailed
below.

These patches have been posted/reviewed on several occasions on LKML and
available in the linux-next tree for about two kernel release cycles.
The necessary x86-specific patch is merged via the x86 tree and the
ARM-specific one via RMK's tree (these only add some vmlinux.lds.S
symbols).

Thanks.


The following changes since commit 991ec02cdca33b03a132a0cacfe6f0aa0be9aa8d:
  Linus Torvalds (1):
        Merge branch 'tracing-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git for-linus

Catalin Marinas (12):
      kmemleak: Add the base support
      kmemleak: Add documentation on the memory leak detector
      kmemleak: Add the slab memory allocation/freeing hooks
      kmemleak: Add the slob memory allocation/freeing hooks
      kmemleak: Add the slub memory allocation/freeing hooks
      kmemleak: Add the vmalloc memory allocation/freeing hooks
      kmemleak: Add kmemleak_alloc callback from alloc_large_system_hash
      kmemleak: Add modules support
      kmemleak: Remove some of the kmemleak false positives
      kmemleak: Enable the building of the memory leak detector
      kmemleak: Simple testing module for kmemleak
      kmemleak: Add the corresponding MAINTAINERS entry

 Documentation/kernel-parameters.txt |    4 +
 Documentation/kmemleak.txt          |  142 ++++
 MAINTAINERS                         |    6 +
 drivers/char/vt.c                   |    7 +
 fs/block_dev.c                      |    6 +
 include/linux/kmemleak.h            |   96 +++
 include/linux/percpu.h              |    5 +
 include/linux/slab.h                |    2 +
 init/main.c                         |    4 +-
 kernel/module.c                     |   56 ++
 lib/Kconfig.debug                   |   32 +
 mm/Makefile                         |    2 +
 mm/kmemleak-test.c                  |  111 +++
 mm/kmemleak.c                       | 1498 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                     |   11 +
 mm/slab.c                           |   32 +-
 mm/slob.c                           |    7 +
 mm/slub.c                           |    5 +-
 mm/vmalloc.c                        |   30 +-
 19 files changed, 2049 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/kmemleak.txt
 create mode 100644 include/linux/kmemleak.h
 create mode 100644 mm/kmemleak-test.c
 create mode 100644 mm/kmemleak.c

-- 
Catalin

