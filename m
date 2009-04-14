Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZDNVtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZDNVtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZDNVtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:49:04 -0400
Received: from gw.goop.org ([64.81.55.164]:50815 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZDNVtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:49:03 -0400
Message-ID: <49E504C1.9010401@goop.org>
Date: Tue, 14 Apr 2009 14:48:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu>
In-Reply-To: <20090414210445.GM955@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Any chance you could support something like this?
>
>   

I think that's already there.  I'm defining 
arch/x86/include/asm/paravirt-trace.h with:

#ifndef _ASM_X86_PARAVIRT_TRACE_H
#define _ASM_X86_PARAVIRT_TRACE_H

#include <linux/tracepoint.h>
#include <asm/paravirt_types.h>

#undef TRACE_SYSTEM
#define TRACE_SYSTEM pvops

#define TRACE_INCLUDE_FILE	paravirt-trace
#define TRACE_INCLUDE_PATH	asm
[...]


Which ends up including <asm/paravirt-trace.h>

    J
