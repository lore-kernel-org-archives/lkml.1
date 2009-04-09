Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZDIDLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZDIDLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZDIDLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:11:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50586 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZDIDLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:11:41 -0400
Message-ID: <49DD6791.2010507@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 11:12:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Whitehouse <swhiteho@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
Subject: Re: Multiple Tracers
References: <1239197703.3359.25.camel@localhost.localdomain> <20090408135312.GR18581@elte.hu> <1239199899.3359.39.camel@localhost.localdomain> <20090408142413.GF12931@elte.hu> <49DD5964.8000803@cn.fujitsu.com> <20090409025507.GB24946@ghostprotocols.net>
In-Reply-To: <20090409025507.GB24946@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 
>> I guess you mean Arnaldo <acme@redhat.com> ;)
> 
> Nope, Tom:
> 
> Message-Id: <1235725261.8512.89.camel@charm-linux>
>  

Ah, sorry for the mistake, I didn't notice that patch, and I thought
Ingo meant the ftrace-plugin patch.

>>> a tracing framework - and i think much of that could be reused to 
>>> add EVENT_TRACE() tracepoints to blktrace too.
>>>
>>> Tom, what's your take on this?
>>>
>>> In general, this is the direction we want to take: EVENT_TRACE() 
>>> tracepoints that can be used in a generic way, in any tracer.
>>>
>> Actually we've planed to do this, and for other tracers.
> 
> Yeah, being able to mix all kinds of tracers is the way to go.
> 
