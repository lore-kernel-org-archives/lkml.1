Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZDNVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZDNVza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZDNVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:55:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44947 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZDNVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:55:19 -0400
Date: Tue, 14 Apr 2009 17:55:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
In-Reply-To: <49E504C1.9010401@goop.org>
Message-ID: <alpine.DEB.2.00.0904141753500.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <49E504C1.9010401@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Jeremy Fitzhardinge wrote:

> Theodore Tso wrote:
> > Any chance you could support something like this?
> > 
> >   
> 
> I think that's already there.  I'm defining
> arch/x86/include/asm/paravirt-trace.h with:
> 
> #ifndef _ASM_X86_PARAVIRT_TRACE_H
> #define _ASM_X86_PARAVIRT_TRACE_H
> 
> #include <linux/tracepoint.h>
> #include <asm/paravirt_types.h>
> 
> #undef TRACE_SYSTEM
> #define TRACE_SYSTEM pvops
> 
> #define TRACE_INCLUDE_FILE	paravirt-trace
> #define TRACE_INCLUDE_PATH	asm
> [...]
> 
> 
> Which ends up including <asm/paravirt-trace.h>

Not quite. It ends up looking like

#include "asm/paravirt-trace.h"

As long as there is no "asm" directory in the include/trace directory, I 
think that is fine.

-- Steve

