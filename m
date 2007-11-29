Return-Path: <linux-kernel-owner+w=401wt.eu-S934090AbXK2WZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbXK2WZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760989AbXK2WZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:25:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881AbXK2WZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:25:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: Linus Torvalds's message of  Thursday, 29 November 2007 10:09:00 -0800 <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071129003849.428E026F8E7@magilla.localdomain>
	<20071129004222.E49AD26F8E7@magilla.localdomain>
	<474EF824.3020806@redhat.com>
	<alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071129222531.EFEA826F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 14:25:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But the ones that do the same thing for fs/es/ds are *not*. Those three 
> registers are kernel mode registers (ds/es are the regular kernel data 
> segment, fs is the per-cpu data segment), and restored on return to user 
> space from the stack.

Um, really?  This is x86-64 code.  AIUI those values don't have any effect
at all in 64-bit mode (as the kernel is).  I haven't found any code in
entry_64.S or ia32entry.S that touches them.  __switch_to uses direct
access to the segment registers just as I've done.


Thanks,
Roland
