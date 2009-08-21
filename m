Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZHUTha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZHUTha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZHUTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZHUTh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:37:29 -0400
Message-ID: <4A8EF765.9050201@redhat.com>
Date: Fri, 21 Aug 2009 12:37:09 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 2/2] tracing: Create generic syscall TRACE_EVENTs
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250795373-32363-2-git-send-email-jistone@redhat.com> <20090821175737.GB2684@redhat.com>
In-Reply-To: <20090821175737.GB2684@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 10:57 AM, Jason Baron wrote:
>> +TRACE_EVENT_WITH_CALLBACK(sys_enter,
> 
> don't we want to change this to something like 'sys_enter_generic'?
> otherwise, looks good.

Since all of the specific events are named "sys_enter_foo", I thought
that it would be clear that an unadorned "sys_enter" was the more
generic syscall event.  Calling it "sys_enter_generic" seems to me by
convention to mean a system call named "generic".

I don't want to bikeshed this though -- if you still think
"sys_enter_generic" is better, then I'll change it.

Thanks,

Josh
