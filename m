Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZBRWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZBRWar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZBRWaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:23 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43872
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751921AbZBRWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:21 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/9] *** SUBJECT HERE ***
Date: Wed, 18 Feb 2009 14:30:11 -0800
Message-Id: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

*** BLURB HERE ***

Jeremy Fitzhardinge (9):
  mm: rearrange exit_mmap() to unlock before arch_exit_mmap
  mm: disable preemption in apply_to_pte_range
  x86/paravirt: remove lazy mode in interrupts
  x86/pvops: replace arch_enter_lazy_cpu_mode with
    arch_start_context_switch
  x86/paravirt: flush pending mmu updates on context switch
  x86/paravirt: allow preemption with lazy mmu mode
  mm: allow preemption in apply_to_pte_range
  x86/paravirt: use percpu_ rather than __get_cpu_var
  x86/paravirt: finish change from lazy cpu to context switch start/end

