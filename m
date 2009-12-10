Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbZLJW0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbZLJW0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbZLJW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:26:49 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:49213
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761937AbZLJW0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:26:48 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dN936eM1419Mzz1202hz4fhzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B217586.5070700@am.sony.com>
Date: Thu, 10 Dec 2009 14:26:14 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>	 <4B216478.3080601@am.sony.com> <1260482698.2146.234.camel@gandalf.stny.rr.com>
In-Reply-To: <1260482698.2146.234.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 22:26:16.0491 (UTC) FILETIME=[C9E1DFB0:01CA79E7]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-12-10 at 13:13 -0800, Tim Bird wrote:
>> I have some patches ...
>>  to make it possible to use arbitrary ftrace plugins
>> at boot time.  (There are issues with the current code for
>> anything other than the bootgraph plugin).
> 
> We already have a way to enable arbitrary ftrace plugins at boot time:
> 
> Try ftrace=function on the command line.

That's what I'm using, but my function_duration tracer didn't
work, because of an issue initializing the trace-option files.
The problem was that the debugfs wasn't initialized yet.
I worked up a simple fix to defer initializing the
trace-option files in debugfs until later in the boot
sequence.

Maybe you've already fixed this.  I'll check out the
latest code and see if I still have problems with it.
If so, I'll send the patches (which are quite small)
for consideration.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

