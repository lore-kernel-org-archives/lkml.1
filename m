Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYAZNBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYAZNBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYAZNA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:00:59 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63039 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYAZNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:00:58 -0500
Date: Sat, 26 Jan 2008 08:00:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pavel Machek <pavel@ucw.cz>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 23/23 -v6] Critical latency timings histogram
In-Reply-To: <20080126091147.GB1794@elf.ucw.cz>
Message-ID: <Pine.LNX.4.58.0801260758060.16244@gandalf.stny.rr.com>
References: <20080126042152.526086719@goodmis.org> <20080126042804.824377395@goodmis.org>
 <20080126091147.GB1794@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jan 2008, Pavel Machek wrote:
>
> Ok, so you are adding new userland interface; I guess you should also
> document it in Documentation/?

I was waiting for someone to ask ;-)

Yes, I'm getting a document ready for the Documentation directory. I was
just making sure the interface was fine befor publishing the doc.

Actually, the patches themselves have been showing the API in the
prologue, and that's what I'll be using for the doc. All is done except
for the new histograms. The format for those was taken directly from the
-rt patch, and I still need to document them, but I've been hesitent,
because I want to clean up the histogram code a bit more.

-- Steve

