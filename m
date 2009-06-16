Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZFPRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZFPRz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZFPRzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:55:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761286AbZFPRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:55:14 -0400
Date: Tue, 16 Jun 2009 10:54:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, npiggin@suse.de,
       jeremy@goop.org, tglx@linutronix.de, hugh.dickins@tiscali.co.uk,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: mm: Read cr2 before prefetching the
 mmap_lock
In-Reply-To: <tip-5dfaf90f8052327c92fbe3c470a2e6634be296c0@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0906161054020.3282@localhost.localdomain>
References: <20090616030522.GA22162@Krystal> <tip-5dfaf90f8052327c92fbe3c470a2e6634be296c0@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, tip-bot for Ingo Molnar wrote:
> 
> It turns out that in current upstream we do exactly that:
> 
> 	prefetchw(&mm->mmap_sem);
> 
> 	/* Get the faulting address: */
> 	address = read_cr2();
> 
> This is not good.

Ack.

		Linus
