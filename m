Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYAGFAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYAGFAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYAGFA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:00:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYAGFA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:00:27 -0500
Message-ID: <4781AFB1.6040807@zytor.com>
Date: Sun, 06 Jan 2008 20:50:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 02/11] Add fastcall to do_IRQ for i386
References: <20080103071609.478486470@goodmis.org> <20080103072226.934978594@goodmis.org> <20080103173639.GB30582@Krystal> <Pine.LNX.4.58.0801031246220.4826@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801031246220.4826@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Thu, 3 Jan 2008, Mathieu Desnoyers wrote:
>> I would propose to try to see how we can #ifdef two different __mcount
>> assembly functions that would prepare the stack appropriately for each
>> REGPARM cases.
> 
> I have to confess that I've been testing this mostly on x86_64, which
> doesn't have the troubles with REGPARM as i386 does. I'll need to
> investigate this a bit deeper on i386 alone.
> 

I thought we had dropped support for the non-REGPARM case, so why don't 
we just make it work for REGPARM and be done with it?

	-hpa

