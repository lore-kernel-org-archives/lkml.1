Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZAZLoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZAZLoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZAZLn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:43:58 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26441 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZAZLn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:43:57 -0500
Date: Mon, 26 Jan 2009 12:42:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org
Subject: Re: [PATCH tip][0/2] ftrace interface for blktrace
Message-ID: <20090126114214.GH30821@kernel.dk>
References: <20090123140617.GB21737@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123140617.GB21737@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23 2009, Arnaldo Carvalho de Melo wrote:
> Hi Jens,
> 
> 	Here is a third version, that also implements blk_add_trace_msg,
> using ftrace_vprintk.
> 
> 	As soon as the TRACE_ITER_CONTEXT_INFO option is implemented
> I'll provide the struct trace_event->bin() callback to synthesize the
> old blktrace record format so that we can test the output of trace_pipe
> with blkparse -i -.
> 
> 	Please let me know if this is acceptable for inclusion on
> linux-tip.

Sure, go ahead and add it!

-- 
Jens Axboe

