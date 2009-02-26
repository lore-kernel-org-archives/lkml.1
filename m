Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZBZHHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZBZHHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZBZHG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:06:58 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:52790 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZBZHG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t3iHqexzeI4UTtIfmUsnaTZQ5Oq4cgT3EZKxpxDWI677I4WWwyorQ7SzozzJV2/wUm
         q5LyZUuA2WmxmvXCQODbwsQDZcqcykxzfZNXk3ITDIP4MCNUtWvDigEU2wkD6nwIElsI
         GddnRhcrOJXdNRq46kfYz+MX4R1lbd0cCwJ6A=
Date: Thu, 26 Feb 2009 08:06:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing/core: make the per cpu trace files in per
	cpu directories
Message-ID: <20090226070651.GA6325@nowhere>
References: <49a632a5.0707d00a.296d.24b3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a632a5.0707d00a.296d.24b3@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:41:38AM +0100, Frederic Weisbecker wrote:
> Impact: scale per cpu tracing
> 
> The per cpu trace files are all in a single directory: /debug/tracing/per_cpu.
> In case of a large number of cpu, the content of this directory becomes messy
> so we create now one directory per cpu inside /debug/tracing/per_cpu which contain
> each their own trace_pipe and trace files.
> 
> Ie:
> 
> nobody@nowhere:/debug/tracing$ ls -R per_cpu
> per_cpu:
> cpu0  cpu1
> 
> per_cpu/cpu0:
> trace  trace_pipe
> 
> per_cpu/cpu1:
> trace  trace_pipe
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>


Oh, I forgot to mention: they apply on top of latest -tip + the ftrace_bprintk 3 patches.

