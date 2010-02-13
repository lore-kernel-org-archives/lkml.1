Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0BMQCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:02:36 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:56896 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0BMQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:02:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/9] Random OF cleanups and merges
To: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Date: Sat, 13 Feb 2010 09:02:25 -0700
Message-ID: <20100213154838.4767.83881.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another batch of cleanup patches from my test-devicetree branch.
A number of cleanups, corrections and minor merges of common code.
Also a patch from Jeremy to make the flat tree work on architectures
without LMB (arm).

Once I've collected acks on these, I'll move them over to my
next-devicetree branch on git://git.secretlab.ca/git/linux-2.6

Cheers,
g.

---

Grant Likely (6):
      of: remove undefined request_OF_resource & release_OF_resource
      of/sparc: Remove sparc-local declaration of allnodes and devtree_lock
      of: move definition of of_chosen into common code.
      of: remove unused extern reference to devtree_lock
      of: put default string compare and #a/s-cell values into common header
      of: Remove old and misplaced function declarations

Jeremy Kerr (3):
      of/flattree: Don't assume HAVE_LMB
      of: protect linux/of.h with CONFIG_OF
      proc_devtree: fix THIS_MODULE without module.h


 arch/microblaze/include/asm/prom.h |   15 ---------------
 arch/microblaze/kernel/prom.c      |    8 +++++---
 arch/powerpc/include/asm/prom.h    |   14 --------------
 arch/powerpc/kernel/prom.c         |   10 +++++-----
 arch/sparc/kernel/prom.h           |    3 ---
 drivers/of/base.c                  |    1 +
 drivers/of/fdt.c                   |    9 ++++++---
 fs/proc/proc_devtree.c             |    1 +
 include/linux/of.h                 |   27 +++++++++++++++++++++++++++
 include/linux/of_fdt.h             |   11 +----------
 10 files changed, 46 insertions(+), 53 deletions(-)
