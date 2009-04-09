Return-Path: <linux-kernel-owner+w=401wt.eu-S935648AbZDIPxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935648AbZDIPxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935737AbZDIPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:53:30 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39103 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935786AbZDIPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=uGKxcBf72Nneqn9m0izhfyMOJCJkXFpv6iJlDDlCjmTj+7q/T5ZVDWythmcw6r6R9w
         34PUtY5oOHOWdzqqr43KE3V7K7Gzbs6yUfroSukv+oMfKuL08bGEizQYZ6ZMzCnLs5zz
         r+JeeW9apba6j01pmRyX7ih799Y7dTT+GwKOM=
Date: Thu, 9 Apr 2009 18:53:20 +0300
From: Pekka Paalanen <pq@iki.fi>
To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [tip:tracing/urgent] tracing: consolidate documents
Message-ID: <20090409185320.4ccba2df@daedalus.pq.iki.fi>
In-Reply-To: <tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org>
References: <49DD6E2B.6090200@cn.fujitsu.com>
	<tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 05:30:47 GMT
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Commit-ID:  66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
> Gitweb:     http://git.kernel.org/tip/66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Thu, 9 Apr 2009 11:40:27 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 9 Apr 2009 07:28:10 +0200
> 
> tracing: consolidate documents
> 
> Move kmemtrace.txt, tracepoints.txt, ftrace.txt and mmiotrace.txt to
> the new trace/ directory.
> 
> I didnt find any references to those documents in both source
> files and documents, so no extra work needs to be done.

There is one reference: kernel/trace/Kconfig, search for MMIOTRACE.
Fix that, and you have my ack on the mmiotrace.txt part.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Pekka Paalanen <pq@iki.fi>

Hey, I didn't say anything yet. Maybe you meant Enberg?
There are at least two Pekkas here :-)

Thanks.


> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> LKML-Reference: <49DD6E2B.6090200@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  Documentation/{ => trace}/ftrace.txt           |    0
>  Documentation/{vm => trace}/kmemtrace.txt      |    0
>  Documentation/{tracers => trace}/mmiotrace.txt |    0
>  Documentation/{ => trace}/tracepoints.txt      |    0
>  4 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/trace/ftrace.txt
> similarity index 100%
> rename from Documentation/ftrace.txt
> rename to Documentation/trace/ftrace.txt
> diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/trace/kmemtrace.txt
> similarity index 100%
> rename from Documentation/vm/kmemtrace.txt
> rename to Documentation/trace/kmemtrace.txt
> diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
> similarity index 100%
> rename from Documentation/tracers/mmiotrace.txt
> rename to Documentation/trace/mmiotrace.txt
> diff --git a/Documentation/tracepoints.txt b/Documentation/trace/tracepoints.txt
> similarity index 100%
> rename from Documentation/tracepoints.txt
> rename to Documentation/trace/tracepoints.txt
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
