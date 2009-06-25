Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZFYCUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZFYCUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbZFYCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:20:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62487 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZFYCUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:20:06 -0400
Message-ID: <4A42DF0D.4030804@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 10:21:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 4/7] V2 add syscall tracepoints
References: <cover.1245770664.git.jbaron@redhat.com> <be540cdf5e8ee54d7cf6933bc4dfb28b38794b28.1245770664.git.jbaron@redhat.com>
In-Reply-To: <be540cdf5e8ee54d7cf6933bc4dfb28b38794b28.1245770664.git.jbaron@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index c55fcce..4416c6f 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -2,6 +2,24 @@
>  #define _TRACE_SYSCALL_H
>  
>  #include <asm/ptrace.h>
> +#include <linux/tracepoint.h>

Normal style:

#include <linux/err.h>
#include <linux/tracepoint.h>

#include <asm/ptrace.h>

> +
> +extern void syscall_regfunc(void);
> +extern void syscall_unregfunc(void);

