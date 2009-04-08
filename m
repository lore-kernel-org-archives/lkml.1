Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbZDHSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbZDHSOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZDHSOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:14:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZDHSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:13:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49DCDFC9.9000505@goop.org>
References: <49DCDFC9.9000505@goop.org> <1238176963-21093-1-git-send-email-jeremy@goop.org> <20090408145440.GN12931@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
Date: Wed, 08 Apr 2009 19:10:21 +0100
Message-ID: <21081.1239214221@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> David, do you have a specific reason for defining
> arch_enter/leave_lazy_cpu_mode() in asm-frv/pgtable.h?  It seems to have come
> in with 28936117af849b8c2fca664a41ea7651a0d99591 "FRV: Add some missng lazy
> MMU hooks for NOMMU mode".  The intention was that asm-generic/pgtable.h
> should supply the default definitions; is that incompatible with nommu or
> something?

I don't remember.  It was over two years ago.  My guess is that it was to get
things to compile.  Note that in NOMMU mode, <asm-generic/pgtable.h> is _not_
#included by <asm-frv/pgtable.h>.

David
