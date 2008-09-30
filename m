Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYI3PUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYI3PUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYI3PUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:20:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:46777 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYI3PUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:20:04 -0400
Date: Tue, 30 Sep 2008 09:20:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20080930092001.69849210@bike.lwn.net>
In-Reply-To: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>
	<20080929233539.GA31143@Krystal>
	<alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
	<20080930000307.GA2929@Krystal>
	<alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
	<20080930034603.GA13801@Krystal>
	<alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 00:00:11 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ah, I believe the disk IO uses the page frame. That might be a bit more 
> difficult to pass the data to disk and still keep information on the
> page frame.

Perhaps I'm speaking out of turn, but I have to wonder: am I the only one
who gets uncomfortable looking at these hacks to overload struct page?  It
seems fragile as all hell; woe to he who tries to make a change to struct
page someday and has to track all of this stuff down.

Are the savings gained by using struct page this way really worth the
added complexity?

jon
