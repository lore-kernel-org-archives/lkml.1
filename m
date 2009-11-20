Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZKTIZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZKTIZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZKTIZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:25:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbZKTIZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:25:07 -0500
Message-ID: <4B065241.5040901@cn.fujitsu.com>
Date: Fri, 20 Nov 2009 16:24:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] tracing: Remove kmemtrace tracer
References: <4B064AF5.9060208@cn.fujitsu.com> <4B064B0B.30207@cn.fujitsu.com> <4B065145.2000709@cs.helsinki.fi>
In-Reply-To: <4B065145.2000709@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2009年11月20日 16:20, Pekka Enberg 写道:
> Li Zefan kirjoitti:
>> The kmem trace events can replace the functions of kmemtrace
>> tracer.
>>
>> And kmemtrace-user can be modified to use trace events.
>> (But after cloning the git repo, I found it's still based on
>> the original relay version..), not to mention now we have
>> 'perf kmem' tool.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> NAK for the time being. "perf kmem" output is not yet as good as that of
> kmemtrace-user.
> 

But is the current kmemtrace-user based on kmemtrace?

>From the git repo:
	http://repo.or.cz/w/kmemtrace-user.git

I found it's still based on relay.

