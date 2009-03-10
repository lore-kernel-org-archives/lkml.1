Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZCJLS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZCJLS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCJLSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:18:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:52449 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZCJLSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NtU9l4F8+UmPsbzaC9YWFUY7EXcoFvuZdJD9mQwqYYF4cF/ryGVhwe8TQNUBaa9coP
         b/3YbRq7DLfgb5Vl1YvdSaU3SIwQ4T0tlDaf1M/bO5YKtfc42mgXiY/tKszl3iJLA6KT
         XU6i4XlpRQN96uFZyPBqN3xrk3G/qgP454zYw=
MIME-Version: 1.0
In-Reply-To: <20090310105624.GD6825@nowhere>
References: <20090310045710.286915983@goodmis.org>
	 <20090310045811.084130677@goodmis.org> <20090310105624.GD6825@nowhere>
Date: Tue, 10 Mar 2009 20:18:47 +0900
X-Google-Sender-Auth: 76503609421fe013
Message-ID: <2f11576a0903100418o5f6215abxad8a49243e3c8142@mail.gmail.com>
Subject: Re: [PATCH 3/7] tracing: use generic __stringify
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/10 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, Mar 10, 2009 at 12:57:13AM -0400, Steven Rostedt wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> Impact: clean up
>>
>> This removes the custom made STR(x) macros in the tracer and uses
>> the generic __stringify macro instead.
>>
>> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>> ---
>
>
> Hi,
>
> Why not simply use the # ?
>
> Frederic.

see following url's xstr macro description.

http://gcc.gnu.org/onlinedocs/gcc-4.3.3/cpp/Stringification.html#Stringification
