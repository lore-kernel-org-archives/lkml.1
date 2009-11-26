Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZKZHcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZKZHcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZKZHcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:32:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZKZHcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:32:52 -0500
Subject: Re: [PATCH 0/9] tracing: Convert some trace events to DEFINE_TRACE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
References: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 02:32:56 -0500
Message-Id: <1259220777.21397.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 15:02 +0800, Li Zefan wrote:
> Convert some trace events defined in include/trace/events/*.h
> to DEFINE_TRACE and DEFINE_TRACE_PRINT.
> 
> This reduces hundreds of code lines, and shrinks the size
> of object files.
> 
> Tested by comparing the formats of each trace_event before
> and after patching.
> 
> This patchset is based on -tip tree, but I've conformed the
> ext4 bits won't conflict with ext4 tree.

Thanks Li!

Ingo or Frederic,

Can you pull these in and test them. I'm about to celebrate my turkey
dinner, and I wont be back until Monday.

-- Steve



> ---
>  include/trace/events/block.h     |  202 ++++++++------------------------------
>  include/trace/events/ext4.h      |  129 +++++++------------------
>  include/trace/events/irq.h       |   46 ++++-----
>  include/trace/events/jbd2.h      |   63 ++----------
>  include/trace/events/kmem.h      |  130 ++++++++-----------------
>  include/trace/events/module.h    |   22 ++---
>  include/trace/events/power.h     |   36 +++----
>  include/trace/events/sched.h     |   18 +---
>  include/trace/events/workqueue.h |   22 ++---
>  mm/page_alloc.c                  |    4 +-
>  mm/util.c                        |    3 -
>  11 files changed, 187 insertions(+), 488 deletions(-)
> 

