Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZALBKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZALBKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZALBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:09:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63825 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZALBJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:09:53 -0500
Message-ID: <496A982E.3020103@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 09:09:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com> <20090111013940.GL12885@elte.hu> <20090111050129.GA6131@nowhere> <20090111051604.GF7061@linux.vnet.ibm.com>
In-Reply-To: <20090111051604.GF7061@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The debugfs and seqfile handling and handled in the statistical
>> tracing engine.
>>
>> You just have to provide an iterator for your stat entries through two callbacks:
>>
>> _ stat_start() -> gives the first entry
>> _ stat_next() -> iterates over the next entry
>>
>> And an output callback
>>
>> _ stat_show() -> print one entry from your stat list
>>
>> And two optional things:
>>
>> _ stat_cmp() -> compare two entries, useful if you want your stats to be sorted
>> _ stat_headers() -> provide the first line in your stat file, typically to describe your columns
>>
>> The last thing you need is to give a name to your trace file.
>> You will retrieve it into /debugfs/tracing/trace_stat/your_file_name as a current snapshot
>> of your stats.
>>
>> It is currently used by the branch tracer, and by a pending patch for a new workqueue
>> tracer which will provide you a simple example.
>>
>> If you have any question about how to use it, don't hesitate to ask.
> 
> Li Zefan, is this something you would be willing to try?  Sounds like
> it might be a good addition.
> 

Sure, I'll try. :)

