Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZDQFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZDQFwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZDQFv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:51:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63271 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZDQFv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:51:58 -0400
Message-ID: <49E81935.8060402@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 13:52:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix file mode of trace and README
References: <49E7EAB6.4070605@cn.fujitsu.com> <20090417054447.GA6020@nowhere>
In-Reply-To: <20090417054447.GA6020@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -	trace_create_file("current_tracer", 0444, d_tracer,
>> +	trace_create_file("current_tracer", 0644, d_tracer,
>>  			&global_trace, &set_tracer_fops);
> 
> 
> 
> Oh!
> I wonder how much time we ran with this false permission.
> It clearly shows a bug in debugfs permission (or something
> near this this layer), we have be running with this file
> for a while and I've never seen any issue while writing into it.
> 
> And we have seen several patches with 0444 permissions for the
> tracing tree containing writeable files, showing that the authors
> ran them whithout problems.
> 

It's not a bug in debugfs or vfs. It's just because root can
do anything. ;)

> Adding Greg in Cc.
> 

