Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZKRJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZKRJa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZKRJa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:30:27 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:50665 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbZKRJaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RWuHJ5ieqOZBPiMGwTjFsKRsOnHT7pCizCM+OHhzpHnlhREeZcpnLY3kNdhb5ZR7l7
         sc6RyvcMbEiwzpNK0f3k+o5SGybgYVgfdiN6CAMbPYqkFueRAGjCfQOiyrhHQv2ofxc3
         yNSg9KPFMv6Y5+xFWRUdoR+P7QKY0WYjavsXU=
MIME-Version: 1.0
In-Reply-To: <20091116202214.GD360@elte.hu>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
	 <20091116083521.GC20672@elte.hu>
	 <c76f371a0911161113v60eef516qee0a1a9cf99d2ae@mail.gmail.com>
	 <20091116202214.GD360@elte.hu>
Date: Wed, 18 Nov 2009 10:30:29 +0100
Message-ID: <c76f371a0911180130uf125f7ev2eb4b6de1549fa04@mail.gmail.com>
Subject: Re: [RFC] observe and act upon workload parallelism: 
	PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked 
	threads)
From: Stijn Devriendt <highguy@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This would be a perfect and suitable use of poll() concepts i think -
> and well-optimized one as well. It could even be plugged into epoll().
>
>        Ingo

Sorry for not replying earlier, but I was knocked out on the couch
(and still am). I'll have a more thorough look later on when my head
stops spinning 'round and 'round.

I must say that even without applying this perf_event to userspace
scheduling, it's probably a nice event to have anyway in order
to measure concurrency in existing applications. That it would
be suitable to actually control parallellism is probably just a nice
extra. But let's look at things again when the clouds have left
the brain ;)

Stijn
