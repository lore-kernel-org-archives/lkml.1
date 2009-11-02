Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZKBPFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZKBPFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZKBPFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:05:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZKBPFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:05:22 -0500
Date: Mon, 2 Nov 2009 16:05:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC Patch 0/4] Enhance perf-events to profile memory accesses
	using hw-breakpoints - ver II
Message-ID: <20091102150503.GE23776@elte.hu>
References: <20091028155827.GA8604@in.ibm.com> <20091029081917.GC26970@elte.hu> <c62985530910310919u6ee28ad8qcaa3046b86ecaaee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62985530910310919u6ee28ad8qcaa3046b86ecaaee@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Well this ascii art should be a bit more complicated actually. But 
> anyway. Prasad's patchset is another branch of evolution of 
> tracing/hw-breakpoints.
>
> I've expressed my opinion about that in a mail yesterday. I basically 
> think it limits the perf events possibilities and rewrites the context 
> binding / register allocation that perf already handles.

Ok, in hindsight i agree with your point of view - we really dont want a 
duplicate layer but a single handler/arbitrer of hw-breakpoint state.

	Ingo
