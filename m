Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbZBYJBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbZBYJBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbZBYJA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:00:57 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62915 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZBYJA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dpoaj8mFF9Wi24QMK1eRJFIfwWErtjaaThbXzl5u3XWl1KHQ36TDZDsjYoWbrL7xev
         QsRiklvMP4q8dxIN1wHeNkbWtYAwnRzIKBOdLPz5M1YcaJ47+H7mknIG+1Tatomi0NhU
         4N1/4gSa7l+HuxuBSqHlJ4eoB1VKtqNi1/lI8=
MIME-Version: 1.0
In-Reply-To: <20090225002852.5ef5b869.akpm@linux-foundation.org>
References: <20090225025608.956691460@goodmis.org>
	 <20090225025753.798204550@goodmis.org>
	 <20090224194548.3effb746.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	 <20090224203308.8d623e0b.akpm@linux-foundation.org>
	 <20090225081118.GC15303@elte.hu>
	 <20090225002852.5ef5b869.akpm@linux-foundation.org>
Date: Wed, 25 Feb 2009 11:00:53 +0200
X-Google-Sender-Auth: e15fea1a18c18c52
Message-ID: <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, Feb 25, 2009 at 10:28 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> A better approach would be to design simple, robust kernel interfaces
> which make sense and which aren't made all complex by putting the user
> interface in kernel space.  And to maintain corresponding userspace
> tools which manipulate and present the IO from those kernel interfaces.

We did this for kmemtrace and quite frankly, I usually end up spending
more time figuring out how to export the data from a virtual machine
than actually analyzing the results. What makes ftrace so cool is the
fact that it has almost zero-overhead for setup and that the
text-based data format plays well with simple scripting tools
available everywhere.

                                     Pekka
