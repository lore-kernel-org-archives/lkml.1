Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJaPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJaPbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYJaPbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:31:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38296 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJaPbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:31:05 -0400
Message-ID: <490B247F.5070603@oracle.com>
Date: Fri, 31 Oct 2008 08:30:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: update txt document
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311049090.20157@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810311049090.20157@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.490B2496.003A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> I finally got around to looking at the review notes.
> 
> On Sun, 26 Oct 2008, Randy Dunlap wrote:
>>>  
>>>   # sysctl kernel.ftrace_enabled=1
>>> - # echo ftrace > /debug/tracing/current_tracer
>>> + # echo function > /debug/tracing/current_tracer
>>>   # echo 1 > /debug/tracing/tracing_enabled
>>>   # usleep 1
>>>   # echo 0 > /debug/tracing/tracing_enabled
>>>   # cat /debug/tracing/trace
>>> -# tracer: ftrace
>>> +# tracer: function
>>>  #
>>>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>>>  #              | |      |          |         |
>> General comment #2: debugfs is normally mounted at /sys/kernel/debug
>> (which Doc/x86/pat.txt, Doc/filesystems/relay.txt,
>> Doc/infiniband/ipoib.txt, and Doc/usb/usbmon.txt know about).
>> Please either use /sys/kernel/debug or use what Doc/kernel-parameters.txt
>> uses: <debugfs> (for the mount point).  I.e., don't use a poor example
>> in the doc text.
> 
> In the beginning of the document I did have a disclaimer:

OK, sorry about that.  Somehow I missed seeing it.

> ------------------------
> To mount the debugfs system:
> 
>   # mkdir /debug
>   # mount -t debugfs nodev /debug
> 
> (Note: it is more common to mount at /sys/kernel/debug, but for simplicity
>  this document will use /debug)
> ------------------------
> 
> I know the recommended place is /sys/kernel/debug, but I never use it. And 
> I know many others that do not either. It is just easier to make the
> /debug directory. I feel this is more of a guideline than something
> that must be enforced.  But if you do feel strongly on this subject, I
> can change it to /sys/kernel/debug (which I absolutely loathe).


-- 
~Randy
