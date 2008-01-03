Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYACRs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYACRs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYACRsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:48:50 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53095 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYACRss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:48:48 -0500
Date: Thu, 3 Jan 2008 12:47:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 02/11] Add fastcall to do_IRQ for i386
In-Reply-To: <20080103173639.GB30582@Krystal>
Message-ID: <Pine.LNX.4.58.0801031246220.4826@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103072226.934978594@goodmis.org>
 <20080103173639.GB30582@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jan 2008, Mathieu Desnoyers wrote:
>
> I would propose to try to see how we can #ifdef two different __mcount
> assembly functions that would prepare the stack appropriately for each
> REGPARM cases.
>

I have to confess that I've been testing this mostly on x86_64, which
doesn't have the troubles with REGPARM as i386 does. I'll need to
investigate this a bit deeper on i386 alone.

-- Steve

