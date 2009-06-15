Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbZFOWlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbZFOWlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZFOWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:40:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761050AbZFOWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:40:48 -0400
Message-ID: <4A36CCFC.8070908@zytor.com>
Date: Mon, 15 Jun 2009 15:36:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
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
References: <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu> <20090615211207.GB12919@Krystal> <20090615211605.GC27100@elte.hu> <20090615213429.GD12919@Krystal> <4A36BF61.10901@zytor.com> <20090615215420.GE12919@Krystal> <4A36C953.8060906@zytor.com> <20090615223038.GA15903@Krystal>
In-Reply-To: <20090615223038.GA15903@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> I'm just thinking that touching or not vmalloc'd areas should not be the
> first thing that comes into the mind of someone willing to write a
> nmi-hooking tracer or oprofile module.
> 

But is HAS to be.  Otherwise you're in deadlock city anyway.

	-hpa

