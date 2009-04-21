Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbZDURnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbZDURnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZDURnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:43:23 -0400
Received: from gw.goop.org ([64.81.55.164]:56569 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbZDURnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:43:22 -0400
Message-ID: <49EE05AC.1070704@goop.org>
Date: Tue, 21 Apr 2009 10:43:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org> <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>
>> I tried disabling frame pointers, but it looked to me like tracing selects
>> them.  Did I misread, or perhaps it was some other config option doing it...
>>     
>
> It is needed for the function tracer (gcc -pg wont work without it). It is 
> the only tracer that selects it.
>   

Ah, right.  I'm never sure what all the trace options actually control, 
so I tend to enable them a bit indescriminately.

    J

