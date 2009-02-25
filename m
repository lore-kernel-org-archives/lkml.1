Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbZBYJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbZBYJTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZBYJS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:18:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbZBYJS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:18:56 -0500
Date: Wed, 25 Feb 2009 01:15:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090225011507.9135b143.akpm@linux-foundation.org>
In-Reply-To: <20090225084000.GB9322@elte.hu>
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	<20090224203308.8d623e0b.akpm@linux-foundation.org>
	<20090225081118.GC15303@elte.hu>
	<20090225002852.5ef5b869.akpm@linux-foundation.org>
	<20090225084000.GB9322@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 09:40:00 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> _Maybe_ some of it (but certainly not all) could be done via 
> klibc - but that got nacked. If you can convince Linus to take 
> klibc and to allow a userspace 'halo' of utilities that are 
> intimate with kernel details into the kernel proper then maybe 
> we could start providing such tools in the kernel proper.

see, there you go!

No, we don't need to merge klibc to be able to develop and deliver
simple, kernel-developer-only userspace tools within the kernel tree. 
For heaven's sake.

Sam had a patchset which scoops up all the compileable .c files in
Documentation/ and actually puts them into a separate directory along
with a makefile.  It worked!  It didn't quite get merged though.

