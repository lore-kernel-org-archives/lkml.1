Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZFIReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZFIReT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFIReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:34:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZFIReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:34:08 -0400
Date: Tue, 9 Jun 2009 13:34:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace
 points and fix
In-Reply-To: <20090609163657.557589106@goodmis.org>
Message-ID: <alpine.DEB.2.00.0906091333330.17452@gandalf.stny.rr.com>
References: <20090609163657.557589106@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Jun 2009, Steven Rostedt wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Li Zefan (1):
>       tracing/events: convert block trace points to TRACE_EVENT()

Ingo,

Hold off on pulling, I'm getting warnings on the compile for the block 
events.

I'll take a look into it.

Thanks,

-- Steve

> 
> Steven Rostedt (1):
>       ring-buffer: fix ret in rb_add_time_stamp
> 
> ----
>  block/blk-core.c             |   16 +-
>  block/elevator.c             |    8 +-
>  drivers/md/dm.c              |    5 +-
>  fs/bio.c                     |    3 +-
>  include/linux/blktrace_api.h |   13 ++
>  include/trace/block.h        |   76 -------
>  include/trace/events/block.h |  483 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/Makefile        |    5 +-
>  kernel/trace/blktrace.c      |   78 +++++++-
>  kernel/trace/ring_buffer.c   |    2 +-
>  mm/bounce.c                  |    5 +-
>  11 files changed, 589 insertions(+), 105 deletions(-)
> -- 
> 
