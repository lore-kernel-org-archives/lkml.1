Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZETChZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZETChZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZETChP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:37:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZETChO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:37:14 -0400
Message-ID: <4A136C2C.1010107@cn.fujitsu.com>
Date: Wed, 20 May 2009 10:34:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: use strlcpy instead of strncpy
References: <4A11480F.3030000@cn.fujitsu.com> <4A11CB5C.8070800@gmail.com> <4A1210B6.80605@cn.fujitsu.com> <4A12AC0D.7000701@s5r6.in-berlin.de>
In-Reply-To: <4A12AC0D.7000701@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Lai Jiangshan wrote:
>> [Impact] cleanup
> 
> Well, not entirely.
> 
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -155,8 +155,8 @@ struct trace_boot_ret {
>>  struct trace_branch {
>>      struct trace_entry    ent;
>>      unsigned            line;
>> -    char            func[TRACE_FUNC_SIZE+1];
>> -    char            file[TRACE_FILE_SIZE+1];
>> +    char            func[TRACE_FUNC_SIZE];
>> +    char            file[TRACE_FILE_SIZE];
>>      char            correct;
>>  };
> 
> (without change of the TRACE_????_SIZE definition)
> 
> Better avoid a categorization of a patch if the change's scope exceeds
> that of the categorization.

I think it's make no sense to change the magic number TRACE_????_SIZE,
I will rewrite my changelog as Frederic suggests.

Thank you very much.

Lai.

