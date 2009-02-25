Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbZBYKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbZBYKYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761492AbZBYKY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:24:27 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:51375 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761279AbZBYKY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fY5OmhedY2C9WNkSZJ5HW5NsVPcv6eDgJcnawYtnbszHDAUlig7tQ/shBHmzN88QDL
         24kryyDkTLCclGyWFpSNYBwNogSz9xn7YPz6NadkDcPP+8GKhcHN6apEWOskC6qwclh4
         r1KPDjX1tb062NbmnqmIrHLX2PJ5obspTLIgw=
MIME-Version: 1.0
In-Reply-To: <20090225020254.97be7715.akpm@linux-foundation.org>
References: <20090225025753.798204550@goodmis.org>
	 <20090224203308.8d623e0b.akpm@linux-foundation.org>
	 <20090225081118.GC15303@elte.hu>
	 <20090225002852.5ef5b869.akpm@linux-foundation.org>
	 <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
	 <20090225012250.db68e480.akpm@linux-foundation.org>
	 <1235554387.3849.30.camel@penberg-laptop>
	 <20090225014442.7b7b7726.akpm@linux-foundation.org>
	 <20090225095623.GB12352@elte.hu>
	 <20090225020254.97be7715.akpm@linux-foundation.org>
Date: Wed, 25 Feb 2009 12:24:20 +0200
X-Google-Sender-Auth: decce7796e373eba
Message-ID: <84144f020902250224kd8475b8yd9fd9f3ece7155e@mail.gmail.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 25 Feb 2009 10:56:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> Since the concept of a kernel tracing facility being
>> self-sufficient and being easy to use is an integral and key
>> concept to ftrace, dont you see why people take your suggestions
>> as a dismissal of the ftrace concept?

On Wed, Feb 25, 2009 at 12:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Nothing I've suggested in any way makes ftrace hard to use.
>
> If you guys had gone this way, you would not have screwed it up as much
> as you're suggesting.

I find it difficult to understand what is it exactly that you're
suggesting. AFAICT, the core of the argument is how much
post-processing should we do in the kernel. Now keeping all
post-processing out of the kernel will make (some) tracers less
user-friendly but we obviously don't want to do a full TeX in the
kernel either.

Maybe identifying the specific plug-ins you have problems with would
be useful? I only know some of the ftrace core and the kmemtrace
plug-in and I suspect the situation is similar for other plug-in
developers as well. So the problem here could be just that you're not
getting the message across to the right people.

                                      Pekka
