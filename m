Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0BAEqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:46:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44591 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0BAEp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:45:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B665C65.3030408@jp.fujitsu.com>
Date: Mon, 01 Feb 2010 13:45:25 +0900
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
 points
References: <4B56A621.2070301@jp.fujitsu.com>	 <20100120083741.GA5020@infradead.org> <1264009339.4561.56.camel@frodo>
In-Reply-To: <1264009339.4561.56.camel@frodo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-01-20 at 03:37 -0500, Christoph Hellwig wrote:
>>> --- linux-2.6.33-rc4-trace/kernel/trace/Makefile~scsi_trace	2010-01-18 16:23:16.000000000 +0900
>>> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/Makefile	2010-01-18 16:23:16.000000000 +0900
>>> @@ -48,6 +48,9 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktra
>>>  ifeq ($(CONFIG_BLOCK),y)
>>>  obj-$(CONFIG_EVENT_TRACING) += blktrace.o
>>>  endif
>>> +ifneq ($(CONFIG_SCSI),)
>>> +obj-$(CONFIG_EVENT_TRACING) += scsitrace.o
>>> +endif
>>>  obj-$(CONFIG_EVENT_TRACING) += trace_events.o
>>>  obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>>>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
>> The code should be built into scsi_mod.ko and thus from drivers/scsi/
>>
> 
> Yes, none of this code belongs in kernel/trace/.

Thanks for the comments, Christoph, Steven.  In v2 patchset that
I'm going to post soon, I've moved the stuff to drivers/scsi/.

Thanks,
Kei

