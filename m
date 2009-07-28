Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZG1WCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZG1WCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZG1WCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:02:51 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61221 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZG1WCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JSK8cp/OLD+ALsIDseyPHnP921/7EXKVt4OcQt69HaMDl7MDyOvN1ehpE33441Sz3u
         sYmSVhCVc9kYbnj8kCN7jsK355CddRLki8Scx3qfxp8VqI9+3rJH3wCcc8G5bxIoXcXL
         W6k/eERJt8xodBHM9N1hyFArF+6kTLHuLTaRQ=
Date: Wed, 29 Jul 2009 00:02:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing/function_graph fixes for 2.6.31
Message-ID: <20090728220247.GA5104@nowhere>
References: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:55:32PM +0200, Frederic Weisbecker wrote:
> Ingo, Thomas,
> 
> Those are two fixes for the function graph tracer for .31
> 
> The first one fixes a possible race condition between a function graph trace
> reader and ring buffer writers, leading to a mixup inside an event entry, or
> worst.
> 
> The second one fixes some issues in the output of the function graph tracer
> while using splice on the trace_pipe file or ftrace_dump().
> 
> Both fixes should also be backported on .30 for the -stable branch.
> 
> Thanks,
> Frederic.



(Changing the title with the [GIT PULL] prefix, in case you miss it.)

Thanks.

 
> The following changes since commit 4733fd328f14280900435d9dbae1487d110a4d56:
>   Benjamin Herrenschmidt (1):
>         mm: Remove duplicate definitions in MIPS and SH
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/fixes
> 
> Lai Jiangshan (2):
>       tracing: Fix invalid function_graph entry
>       tracing: Fix missing function_graph events when we splice_read from trace_pipe
> 
>  kernel/trace/trace.c                 |   10 +++++++---
>  kernel/trace/trace_functions_graph.c |   11 +++++++++--
>  2 files changed, 16 insertions(+), 5 deletions(-)

