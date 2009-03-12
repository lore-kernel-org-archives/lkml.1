Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZCLEHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZCLEHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZCLEHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:07:00 -0400
Received: from ozlabs.org ([203.10.76.45]:58366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZCLEG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:06:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] Wrapper macros for struct task_struct and struct mm_struct cpumask transition
Date: Thu, 12 Mar 2009 14:36:52 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121436.53055.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 99adcd9d67aaf04e28f5ae96df280f236bde4b66:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (2):
      cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
      cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.

 include/linux/mm_types.h |    3 +++
 include/linux/sched.h    |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)
