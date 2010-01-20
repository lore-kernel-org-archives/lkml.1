Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113Ab0ATRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0ATRoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615Ab0ATRoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:44:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0ATRoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:44:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=i9DFcELmdDQA:10 a=-FhkqIMy_7m3dT-vmCgA:9 a=oha-9YtFOp1aVyhaQSll6B9OsZwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
 points
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
In-Reply-To: <20100120083741.GA5020@infradead.org>
References: <4B56A621.2070301@jp.fujitsu.com>
	 <20100120083741.GA5020@infradead.org>
Content-Type: text/plain
Date: Wed, 20 Jan 2010 12:42:19 -0500
Message-Id: <1264009339.4561.56.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 03:37 -0500, Christoph Hellwig wrote:
> > --- linux-2.6.33-rc4-trace/kernel/trace/Makefile~scsi_trace	2010-01-18 16:23:16.000000000 +0900
> > +++ linux-2.6.33-rc4-trace-kei/kernel/trace/Makefile	2010-01-18 16:23:16.000000000 +0900
> > @@ -48,6 +48,9 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktra
> >  ifeq ($(CONFIG_BLOCK),y)
> >  obj-$(CONFIG_EVENT_TRACING) += blktrace.o
> >  endif
> > +ifneq ($(CONFIG_SCSI),)
> > +obj-$(CONFIG_EVENT_TRACING) += scsitrace.o
> > +endif
> >  obj-$(CONFIG_EVENT_TRACING) += trace_events.o
> >  obj-$(CONFIG_EVENT_TRACING) += trace_export.o
> >  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
> 
> The code should be built into scsi_mod.ko and thus from drivers/scsi/
> 

Yes, none of this code belongs in kernel/trace/.

-- Steve


