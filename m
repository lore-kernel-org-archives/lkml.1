Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYLCUwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYLCUwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYLCUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:52:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYLCUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:52:26 -0500
Date: Wed, 3 Dec 2008 15:52:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 3/3] ftrace: trace single pid for function graph tracer
In-Reply-To: <20081203124915.2eb9e7cd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812031551360.29045@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org> <20081203203829.362295724@goodmis.org> <20081203124915.2eb9e7cd.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Andrew Morton wrote:

> On Wed, 03 Dec 2008 15:36:59 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch makes the changes to set_ftrace_pid apply to the function
> > graph tracer.
> 
> That sentence needs help.

Medic!

> 
> >  # echo $$ > /debugfs/tracing/set_ftrace_pid
> >  # echo function_graph > /debugfs/tracing/current_tracer
> > 
> > Will cause only the current task to be traced. Note, the trace flags are
> > also inherited by child processes, so the children of the shell
> > will also be traced.
> 
> Where did we end up on the pids-arent-unique issue?  Gave up?

Nah, patch 2 opens the door for a solution. I'm just pawning the work off 
to the container folks ;-)

-- Steve

