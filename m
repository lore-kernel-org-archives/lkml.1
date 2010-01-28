Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758Ab0A1EVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0A1EVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707Ab0A1EVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:21:43 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49990 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0A1EVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:21:43 -0500
Date: Thu, 28 Jan 2010 09:51:39 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
	CONFIG_PREEMPT=y
Message-ID: <20100128042139.GA29044@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4B5E476C.9030303@redhat.com> <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 04:55:31PM -0500, Masami Hiramatsu wrote:
> Disable kprobe booster when CONFIG_PREEMPT=y, because it can't ensure
> that all kernel threads preempted on kprobe's boosted slot run out from
> the slot even using freeze_processes().
> 
> The booster on preemptive kernel will be resumed if synchronize_tasks()
> or something like that is introduced.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
