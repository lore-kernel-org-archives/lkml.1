Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYI3AMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYI3AMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYI3AMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:12:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYI3AMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:12:05 -0400
Date: Mon, 29 Sep 2008 20:12:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
In-Reply-To: <20080930000307.GA2929@Krystal>
Message-ID: <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com> <20080929233539.GA31143@Krystal> <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
 <20080930000307.GA2929@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > Thanks! I must have been lucky some how not to trigger this :-/
> > 
> 
> My guess is that you never free your buffers in your test cases. I don't
> know if it was expected; probably not if your code is built into the
> kernel.

Actually my resize does free the buffers and I did test this. I probably 
never ran the trace when testing the freeing which means those pointers 
could have luckily not have been changed.

-- Steve

