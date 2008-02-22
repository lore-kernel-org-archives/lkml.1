Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbYBVWJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbYBVWJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYBVWJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:09:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbYBVWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=L3HLC4zxGcKw7WPe+RLGxqz2JTeQYxZ7JTV+BWpzfl4IMm2d/EeLtuTaQ5woOzupBgBhk3v27zKrHlDYx+Qc+h33owWuK7YI1egwS2Qnt+qMVfLnbrA9dSf8iTgToYHNJK2Cj/w3sLD6eETi4e6jviTzqTzRPZgb1Jho/dEToJI=
Date: Fri, 22 Feb 2008 23:09:10 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/20] Various Coding Style fixes
Message-ID: <20080222230910.2c175eb5@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various coding style fixes.

Paolo Ciarrocchi (20):
      x86: Coding Style fix to arch/x86/boot/pm.c
      x86: Coding Style fixes to arch/x86/kernel/summit_32.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/intel.c
      x86: Coding Style fixes to arch/x86/oprofile/init.c
      x86: Coding Style fixes to arch/x86/lib/strstr_32.c
      x86: Coding Style fixes to arch/x86/kernel/mca_32.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/mtrr/state.c
      x86: Coding Style fixes to arch/x86/lib/memcpy_32.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/transmeta.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/amd.c
      x86: Coding Style fixes to arch/x86/kernel/vm86_32.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/non-fatal.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/winchip.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/mce_32.c
      x86: Coding Style fixes to arch/x86/boot/cpucheck.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/cyrix.c
      x86: Coding Style fixes to arch/x86/oprofile/nmi_timer_int.c
      x86: Coding Style fixes to arch/x86/kernel/acpi/sleep.c
      x86: Coding Style fixes to arch/x86/kernel/msr.c
      x86: Coding Style fixes to arch/x86/xen/multicalls.c

 arch/x86/boot/cpucheck.c               |   20 ++--
 arch/x86/boot/pm.c                     |    2 +-
 arch/x86/kernel/acpi/sleep.c           |    2 +-
 arch/x86/kernel/cpu/amd.c              |   94 +++++++++---------
 arch/x86/kernel/cpu/cyrix.c            |  115 +++++++++++-----------
 arch/x86/kernel/cpu/intel.c            |   83 ++++++++-------
 arch/x86/kernel/cpu/mcheck/mce_32.c    |   50 +++++-----
 arch/x86/kernel/cpu/mcheck/non-fatal.c |   21 ++--
 arch/x86/kernel/cpu/mcheck/winchip.c   |    8 +-
 arch/x86/kernel/cpu/mtrr/state.c       |   14 ++-
 arch/x86/kernel/cpu/transmeta.c        |   22 ++--
 arch/x86/kernel/mca_32.c               |   96 ++++++++++--------
 arch/x86/kernel/msr.c                  |    4 +-
 arch/x86/kernel/summit_32.c            |   43 ++++----
 arch/x86/kernel/vm86_32.c              |  174 ++++++++++++++++----------------
 arch/x86/lib/memcpy_32.c               |    2 +-
 arch/x86/lib/strstr_32.c               |    4 +-
 arch/x86/oprofile/init.c               |   13 ++-
 arch/x86/oprofile/nmi_timer_int.c      |    6 +-
 arch/x86/xen/multicalls.c              |    4 +-
 20 files changed, 403 insertions(+), 374 deletions(-)

