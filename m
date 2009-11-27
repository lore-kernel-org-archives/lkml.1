Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZK0ED4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZK0ED4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZK0ED4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:03:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZK0EDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:03:55 -0500
Message-ID: <4B0F4F63.6040307@cn.fujitsu.com>
Date: Fri, 27 Nov 2009 12:02:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace_syscalls: add missed field
References: <4B0E330D.1070206@cn.fujitsu.com> <20091126223153.GA7177@nowhere>
In-Reply-To: <20091126223153.GA7177@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Nov 26, 2009 at 03:49:33PM +0800, Lai Jiangshan wrote:
>> Field syscall number is missed in syscall_enter_define_fields()/
>> syscall_exit_define_fields().
>>
>> syscall number is also needed for event filter or other users.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> 


For all kinds of tracer, all fields are "defined"
by trace_define_field(), except this one.
Maybe because I don't like inconsistent codes.

> 
> Well, I don't think it's very useful for in-kernel filtering.
> Filtering a syscall event by its number would mean filtering all
> event for this syscall. This is the same as not tracing it.
> 
> Or do you have other usecases in mind?
> 

Current, only filter use struct ftrace_event_call->fields,
so there is no other usecases ^_^.
But my next take of "tracing: use defined fields to print formats"
will use it.
