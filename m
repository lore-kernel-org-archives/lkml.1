Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZI1QtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZI1QtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZI1QtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZI1QtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:49:00 -0400
Message-ID: <4AC0E9C4.50601@redhat.com>
Date: Mon, 28 Sep 2009 12:52:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH tracing/kprobes 2/5] tracing/kprobes: Avoid field
 name	confliction
References: <20090925191424.12939.91503.stgit@omoto> <20090925191505.12939.69682.stgit@omoto> <4AC01D6D.9070008@cn.fujitsu.com>
In-Reply-To: <4AC01D6D.9070008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +/* Reserved field names */
>> +#define FIELD_STRING_IP "ip"
>> +#define FIELD_STRING_NARGS "nargs"
>> +#define FIELD_STRING_RETIP "ret_ip"
>> +#define FIELD_STRING_FUNC "func"
>> +
>> +const char *reserved_field_names[] = {
>> +	"common_type",
>> +	"common_flags",
>> +	"common_preempt_count",
>> +	"common_pid",
>> +	"common_tgid",
>
> There is a new common field "common_lock_depth"

Thanks, I'll add it.
Perhaps, I might need to have more generic check.
(check in define_field?)

Thank you!

>
>> +	FIELD_STRING_IP,
>> +	FIELD_STRING_NARGS,
>> +	FIELD_STRING_RETIP,
>> +	FIELD_STRING_FUNC,
>> +};

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

