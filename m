Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZLAQUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZLAQUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZLAQUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:20:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZLAQUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:20:01 -0500
Date: Tue, 1 Dec 2009 11:19:06 -0500
From: Jason Baron <jbaron@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] trace_syscalls: remove duplications
Message-ID: <20091201161905.GA2641@redhat.com>
References: <4B14D26A.1040000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B14D26A.1040000@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 04:23:06PM +0800, Lai Jiangshan wrote:
> trace_syscalls introduces a lot of duplicate functions
> to all syscalls. These series patches remove them.
> 
>    text    data     bss     dec     hex filename
>  630068  152084  531376 1313528  140af8 kernel/built-in.o.old
>  593997  151988  531824 1277809  137f71 kernel/built-in.o.new
> 
> patch 1~4 is for preparing.
> patch 5~6 remove duplications
> patch 7 cleanups
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/syscalls.h      |   73 ++++--------------------
>  include/trace/syscall.h       |   20 ++----
>  kernel/trace/trace_syscalls.c |  124 ++++++++++++------------------------------
>  3 files changed, 57 insertions(+), 160 deletions(-)
> 
> 

nice simplifications! ack to the whole series.

Acked-by: Jason Baron <jbaron@redhat.com>

