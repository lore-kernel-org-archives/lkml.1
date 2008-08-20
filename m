Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYHTLUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYHTLUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYHTLUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:20:31 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:59649 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752829AbYHTLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:20:30 -0400
Message-ID: <48ABFD77.6030701@extricom.com>
Date: Wed, 20 Aug 2008 14:18:15 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com> <48AAB7FF.4070502@extricom.com> <alpine.DEB.1.10.0808191614380.4957@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808191614380.4957@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 19 Aug 2008, Eran Liberty wrote:
>
>   
>> Steven Rostedt wrote:
>>     
>>>   
>>>       
>>>> Testing tracer sched_switch: PASSED
>>>> Testing tracer ftrace: PASSED
>>>> Testing dynamic ftrace: PASSED
>>>>         
>
> Do you have PREEMPT_TRACER enabled, or any other tracer for that matter?
>
> -- Steve
>   
I can see stack trace & context trace, but they are derived from other 
choices (I can not un select them)

cat .config | grep TRACE
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_STACKTRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_FTRACE=y
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
>   
>>>> Oops: Exception in kernel mode, sig: 11 [#1]
>>>> Exsw1600
>>>> Modules linked in:
>>>> NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
>>>>     
>>>>         
>
>
>   

