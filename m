Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYI3EA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYI3EA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 00:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbYI3EAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 00:00:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYI3EAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 00:00:13 -0400
Date: Tue, 30 Sep 2008 00:00:11 -0400 (EDT)
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
In-Reply-To: <20080930034603.GA13801@Krystal>
Message-ID: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com> <20080929233539.GA31143@Krystal> <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com> <20080930000307.GA2929@Krystal>
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> 
> I also got some corruption of the offset field in the struct page I use.
> I think it might be related to the fact that I don't set the PG_private
> bit (slob does set it when the page is in its free pages list). However,
> given I'd like to pass the buffer pages to disk I/O and for network

Ah, I believe the disk IO uses the page frame. That might be a bit more 
difficult to pass the data to disk and still keep information on the
page frame.

-- Steve

