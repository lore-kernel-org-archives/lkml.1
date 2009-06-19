Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZFSDM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZFSDM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZFSDMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:12:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZFSDMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:12:50 -0400
Message-ID: <4A3B028C.2040902@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 11:14:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       bligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 5/7] add syscall tracepoints
References: <cover.1244837725.git.jbaron@redhat.com> <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com> <20090619021418.GC7903@nowhere>
In-Reply-To: <20090619021418.GC7903@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Jun 12, 2009 at 05:24:59PM -0400, Jason Baron wrote:
>> update FTRACE_SYSCALL_MAX to the current number of syscalls
>>
>>
>> Signed-off-by: Jason Baron <jbaron@redhat.com>
>>
>> ---
>>  arch/x86/include/asm/ftrace.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
>> index bd2c651..d16d195 100644
>> --- a/arch/x86/include/asm/ftrace.h
>> +++ b/arch/x86/include/asm/ftrace.h
>> @@ -30,9 +30,9 @@
>>  
>>  /* FIXME: I don't want to stay hardcoded */
> 
> 
> BTW, is there a way to know this size dynamically?
> Or is there already a hardcoded number of syscalls somewhere
> in x86?
> 

Does this patchset head for .31 or .32? If for .32, then this patch should
go into .31 I think.

