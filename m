Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYIZTSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYIZTSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYIZTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:17:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:47287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYIZTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:17:55 -0400
Subject: Re: [PATCH v6] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>
	 <20080925185236.244343232@goodmis.org>
	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
	 <48DC406D.1050508@redhat.com>
	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 21:17:13 +0200
Message-Id: <1222456633.16700.292.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
> +#define CHECK_COND(buffer, cond)                       \
> +       if (unlikely(cond)) {                           \
> +               atomic_inc(&buffer->record_disabled);   \
> +               WARN_ON(1);                             \
> +               return -1;                              \
> +       }

Arjan, any preferences wrt kerneloops.org?

