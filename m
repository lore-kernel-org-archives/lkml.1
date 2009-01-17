Return-Path: <linux-kernel-owner+w=401wt.eu-S1765724AbZAQTQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765724AbZAQTQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbZAQTP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:15:57 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1083 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760683AbZAQTP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:15:56 -0500
Date: Sat, 17 Jan 2009 20:14:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090117191430.GA30821@kernel.dk>
References: <20090116181611.GE6562@ghostprotocols.net> <20090117190913.GA17722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117190913.GA17722@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17 2009, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Hi Jens,
> > 
> > 	The patch below adds a ftrace interface for blktrace, allowing 
> > people to use it without any required userspace tools, using sysfs to 
> > setup the act_mask, pid, start_lba, end_lba.
> 
> Very nice patch!
> 
> Jens, i'm wondering what's your take on this direction is. I think the 
> consolidation effect is great and the built-in IO tracing capabilities are 
> very nice.

I like the current patch, from a quick look. I'll look more soonish
(monday). I've always liked the concept of being able to mix various
traces into the same stream, since it makes it MUCH easier to see what
on earth is going wrong. What I didn't like in the patches Acme did was
the enable part, I'll need to look into that. Again, from a quick look,
what is the BKL doing in there?!

> We can still get the raw events too and do user-space post-processing, 
> when that is desired - so this does not limit anything that blktrace was 
> able to do before - it only extends on it.
> 
> Is there any particular blktrace feature you can think of that is not 
> present in the blktrace ftrace plugin?

Can't answer that yet, I'll give it a more thorough look next week.

-- 
Jens Axboe

