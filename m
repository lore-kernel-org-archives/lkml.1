Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYISVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYISVoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYISVn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:43:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25907 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYISVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:43:56 -0400
Date: Fri, 19 Sep 2008 14:42:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Martin Bligh" <mbligh@google.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-Id: <20080919144258.ac787fdf.randy.dunlap@oracle.com>
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 14:33:42 -0700 Martin Bligh wrote:

> STORAGE
> -------
> 
> We will support multiple buffers for different tracing systems, with
> separate names, event id spaces.
> Event ids are 16 bit, dynamically allocated.

What are these (like)?

> A "one line of text" print function will be provided for each event,
> or use the default (probably hex printf)
> Will provide a "flight data recorder" mode, and a "spool to disk" mode.
> 
> Circular buffer per cpu, protected by per-cpu spinlock_irq
> Word aligned records.

Arch-specific "word"?
or some fixed-size-for-all-systems (so that trace buffers can be
shared/used on other systems?)  Preferably the latter.


> Variable record length, header will start with length record.
> Timestamps in fixed timebase, monotonically increasing (across all CPUs)

what timestamp resolution?


---
~Randy
