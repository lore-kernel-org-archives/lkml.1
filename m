Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYLCUuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYLCUuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYLCUuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:50:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbYLCUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:50:21 -0500
Date: Wed, 3 Dec 2008 12:49:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 3/3] ftrace: trace single pid for function graph tracer
Message-Id: <20081203124915.2eb9e7cd.akpm@linux-foundation.org>
In-Reply-To: <20081203203829.362295724@goodmis.org>
References: <20081203203656.776893226@goodmis.org>
	<20081203203829.362295724@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 15:36:59 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch makes the changes to set_ftrace_pid apply to the function
> graph tracer.

That sentence needs help.

>  # echo $$ > /debugfs/tracing/set_ftrace_pid
>  # echo function_graph > /debugfs/tracing/current_tracer
> 
> Will cause only the current task to be traced. Note, the trace flags are
> also inherited by child processes, so the children of the shell
> will also be traced.

Where did we end up on the pids-arent-unique issue?  Gave up?
