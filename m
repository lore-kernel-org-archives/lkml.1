Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZHRWLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZHRWLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZHRWLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:11:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZHRWLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:11:50 -0400
Message-ID: <4A8B26F8.3000301@redhat.com>
Date: Tue, 18 Aug 2009 15:11:04 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Move tracepoint callbacks into DEFINE
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <20090818141906.GA2669@redhat.com>
In-Reply-To: <20090818141906.GA2669@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 07:19 AM, Jason Baron wrote:
> this makes sense...Ingo also suggested having the two high level
> tracepoints be 'TRACE_EVENT' style. That is we should be able to
> register with the syscall entry and get the *all* the syscall numbers
> and arguments, and likewise on exit we should be able to get *all*
> syscall exit return values. see:
> 
> http://marc.info/?l=linux-kernel&m=125008740803571&w=2 
> 
> does this patch allow/do that?

It does allow this, and I am working on a patch to do it.  There are a
few naming conflicts between trace_syscalls.c and the stuff that ftrace
generates for "TRACE_EVENT(syscall_enter, ...)", but I will post soon
with a patch to resolve this.

Thanks,

Josh
