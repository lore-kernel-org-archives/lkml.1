Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYA1L7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYA1L7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYA1L7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:59:09 -0500
Received: from gecko.sbs.de ([194.138.37.40]:22111 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYA1L7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:59:08 -0500
Message-ID: <479DC1AB.1060304@siemens.com>
Date: Mon, 28 Jan 2008 12:51:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/20 -v5] add notrace annotations for NMI routines
References: <20080123160236.969334052@goodmis.org> <20080123160442.063076557@goodmis.org> <20080123213139.GB2282@Krystal> <Pine.LNX.4.58.0801260024270.11589@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801260024270.11589@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 23 Jan 2008, Mathieu Desnoyers wrote:
> 
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>> This annotates NMI functions with notrace. Some tracers may be able
>>> to live with this, but some cannot. So we turn off NMI tracing.
>>>
>>> One solution might be to make a notrace_nmi which would only turn
>>> off NMI tracing if a trace utility needed it off.
>>>
>> Is this still needed with the atomic clocksource read ?
>>
> 
> Before you ask again, I've still included this in -v6, simply because I
> didn't get a chance to test it without this patch. I'll try to remember to
> do that on Monday.

Only in case you finally have to keep the annotations for the posted
tracer: Then please make it a Kconfig selectable restriction, because
there are use cases of the mcount hook where you are interested in NMI
invocations.

TiA,
Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
