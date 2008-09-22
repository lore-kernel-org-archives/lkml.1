Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYIVJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYIVJ5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIVJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:57:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYIVJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:57:37 -0400
Subject: Re: Unified tracing buffer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 11:57:17 +0200
Message-Id: <1222077437.7470.5.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-20 at 05:03 -0400, Steven Rostedt wrote:

> Oh, and all commands should start with the namespace.
> 
>   ring_buffer_alloc()
>   ring_buffer_free()
>   ring_buffer_record_event()

I really think we should separate the ringbuffer management from the
event stuff.

