Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935Ab0ATIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab0ATIht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819Ab0ATIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:37:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0ATIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:37:47 -0500
Date: Wed, 20 Jan 2010 03:37:41 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
	points
Message-ID: <20100120083741.GA5020@infradead.org>
References: <4B56A621.2070301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56A621.2070301@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.33-rc4-trace/kernel/trace/Makefile~scsi_trace	2010-01-18 16:23:16.000000000 +0900
> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/Makefile	2010-01-18 16:23:16.000000000 +0900
> @@ -48,6 +48,9 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktra
>  ifeq ($(CONFIG_BLOCK),y)
>  obj-$(CONFIG_EVENT_TRACING) += blktrace.o
>  endif
> +ifneq ($(CONFIG_SCSI),)
> +obj-$(CONFIG_EVENT_TRACING) += scsitrace.o
> +endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events.o
>  obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o

The code should be built into scsi_mod.ko and thus from drivers/scsi/

