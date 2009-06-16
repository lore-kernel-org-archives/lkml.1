Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbZFPSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbZFPSiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbZFPSiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:38:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZFPSiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:38:06 -0400
Message-ID: <4A37B8CF.8090804@zytor.com>
Date: Tue, 16 Jun 2009 08:22:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <20090615213429.GD12919@Krystal> <4A36BF61.10901@zytor.com> <20090615215420.GE12919@Krystal> <4A36C953.8060906@zytor.com> <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com> <20090616030522.GA22162@Krystal> <20090616083343.GD16229@elte.hu> <20090616141956.GB6541@Krystal>
In-Reply-To: <20090616141956.GB6541@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> With respect to cr2, yes, this is the only window we care about.
> However, the rest of vmalloc_fault() must be audited for other non
> nmi-suitable data structure use (e.g. "current"), which I did in the
> past.
> 
> My intent was just to respond to Peter's concerns by showing that the
> part of page fault handler which needs to be NMI-reentrant is really not
> that big.
> 

Even if that is true now, you want it to be true for all future time,
and all to support an out-of-tree piece of code.  All of this is
virtually impossible to test for without said out-of-tree piece of code,
so I will object to it anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

