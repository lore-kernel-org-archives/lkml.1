Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZCDEoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZCDEoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZCDEoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:44:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZCDEoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:44:12 -0500
Message-ID: <49AE05CD.9000402@zytor.com>
Date: Tue, 03 Mar 2009 20:38:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] tracing: add binary buffer files for use with splice
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org> <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>> Conventionally a read() system call will return the number of bytes
>> copied, and will only return -EFOO if the number of bytes copied was
>> zero.
>>
>> Lots of parts of the kernel break this, but it's usually device drivers
>> and scruffy pseudo files, in which case a partial file read doesn't
>> make much sense.  This doesn't make the broken behaviour right, but at
>> least we have a bit of a weaselly excuse in that case.
> 
> I just went by the read man page:
> 
>        EFAULT buf is outside your accessible address space.

Yes, and that is the correct value if no bytes were copied.

	-hpa

