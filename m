Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYI3SCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYI3SCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYI3SCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:02:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYI3SCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:02:35 -0400
Date: Tue, 30 Sep 2008 14:02:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809301350410.6224@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0809301402060.6224@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222796952.24384.25.camel@twins>
 <alpine.DEB.1.10.0809301350410.6224@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Steven Rostedt wrote:
> 
> In ring_buffer_allocate_cpu:
> 
> 	struct buffer_page *bpage;
> 	struct unsigned long addr;

Of course we would not be declaring a "struct unsigned long" ;-)

-- Steve

