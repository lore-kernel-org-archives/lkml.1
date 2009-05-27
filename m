Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbZE0UTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbZE0UTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933697AbZE0USA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:18:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672AbZE0UR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:17:59 -0400
Date: Wed, 27 May 2009 22:17:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, hpa@zytor.com, seto.hidetoshi@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Please pull from mce3 tree
Message-ID: <20090527201759.GA7893@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the updated mce3 tree. That's basically Ingo's tip x86/mce2
tree, only rebased to 2.6.30-rc7 and with some compilation bugs fixed
and one patch reverted (with the agreement of the patch author)

I folded the fixes into the original patches with comments.

Please add to tip.

-Andi

The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3

Hidetoshi Seto (2):
      x86, mce: Add mce_threshold option for intel cmci
      x86, mce: Cleanup param parser

Ingo Molnar (17):
      x86, mce: clean up the mce_64.c code
      x86, mce: clean up the sysfs variables namespace
      x86, mce: clean up mce_amd_64.c
      x86, mce: clean up p4.c
      x86, mce: clean up therm_throt.c
      x86, mce: clean up p6.c
      x86, mce: clean up k7.c
      x86, mce: clean up non-fatal.c
      x86, mce: clean up mce_32.c
      x86, mce: clean up p5.c
      x86, mce: clean up winchip.c
      x86, mce: clean up mce.h
      x86, mce: prepare mce.h and mce_64.c for unification
      x86, mce: prepare unification
      x86, mce: unify, prepare for 32-bit
      x86, mce: unify
      x86, mce: print number of MCE banks

Thomas Gleixner (4):
      mce: unify Intel thermal init, prepare
      x86, mce: unify the Intel thermal interrupt code
      x86, mce: clean up mce_intel.c
      x86, mce: clean up mce_64.c

 Documentation/kernel-parameters.txt            |    5 +
 arch/x86/include/asm/mce.h                     |   38 ++--
 arch/x86/include/asm/msr-index.h               |   11 +
 arch/x86/kernel/cpu/mcheck/Makefile            |    5 +-
 arch/x86/kernel/cpu/mcheck/k7.c                |   36 ++-
 arch/x86/kernel/cpu/mcheck/{mce_64.c => mce.c} |  391 ++++++++++++++++--------
 arch/x86/kernel/cpu/mcheck/mce.h               |   21 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c            |   76 -----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c        |  187 +++++++-----
 arch/x86/kernel/cpu/mcheck/mce_intel.c         |   76 +++++
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c      |  112 ++++----
 arch/x86/kernel/cpu/mcheck/non-fatal.c         |   57 ++--
 arch/x86/kernel/cpu/mcheck/p4.c                |   84 ++----
 arch/x86/kernel/cpu/mcheck/p5.c                |   43 ++-
 arch/x86/kernel/cpu/mcheck/p6.c                |   26 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c       |   74 +++---
 arch/x86/kernel/cpu/mcheck/winchip.c           |   17 +-
 17 files changed, 720 insertions(+), 539 deletions(-)
 rename arch/x86/kernel/cpu/mcheck/{mce_64.c => mce.c} (80%)
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_32.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c

-- 
ak@linux.intel.com -- Speaking for myself only.
