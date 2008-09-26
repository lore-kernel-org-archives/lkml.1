Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYIZSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYIZSax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYIZSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:30:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:21251 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYIZSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :thread-index:in-reply-to:mime-version:content-type
         :content-transfer-encoding;
        b=ecmWVxjQdVm0R/1ewcg9CDbliTwZtmL6uNNkZUmtxSAelZlIci+/Ceab663NuLEn0v
         /2bQy1JTiLnTWQQPKLCmjzxWU+wFZml0C3xOz0/7FbaEOPEAI774BK3D/QXmEU9T9p9a
         ElDImbMF3b5Qp0pFWzCrEZZ/+GZv/VcR7EI6k=
User-Agent: Microsoft-Entourage/12.1.0.080305
Date: Fri, 26 Sep 2008 12:30:34 -0600
Subject: Re: [PATCH v6] Unified trace buffer
From: Richard Holden <aciddeath@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, <prasad@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       <hch@lst.de>, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Message-ID: <C502866A.12064%aciddeath@gmail.com>
Thread-Topic: [PATCH v6] Unified trace buffer
Thread-Index: AckgBfaLaDATlWmLiE6MZav0+5zaNA==
In-Reply-To: <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/08 12:05 PM, "Steven Rostedt" <rostedt@goodmis.org> wrote:

> ring_buffer_alloc: create a new ring buffer. Can choose between
> overwrite or consumer/producer mode. Overwrite will
> overwrite old data, where as consumer producer will
> throw away new data if the consumer catches up with the
> producer.  The consumer/producer is the default.

Forgive me if I've gotten this wrong but the terminology seems backwards
Here, I would think we only throw away new data if the producer catches up
with the consumer, if the consumer catches up with the producer we're
reading data as fast as it's being written.

> 
> ring_buffer_write: writes some data into the ring buffer.
> 
> ring_buffer_peek: Look at a next item in the cpu buffer.
> ring_buffer_consume: get the next item in the cpu buffer and
> consume it. That is, this function increments the head
> pointer.

Here too, I would think that consuming data would modify the tail pointer.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Just trying to understand the terminology before I look at the code so I'm
sorry if I have just completely misunderstood.

-Richard Holden


