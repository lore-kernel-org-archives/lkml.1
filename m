Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZIVLf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZIVLf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZIVLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbZIVLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:35:27 -0400
Message-ID: <4AB8B65F.7030602@redhat.com>
Date: Tue, 22 Sep 2009 14:34:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
In-Reply-To: <1253618894.13917.18.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 02:28 PM, Mike Galbraith wrote:
> On Tue, 2009-09-22 at 12:13 +0300, Avi Kivity wrote:
>
>    
>> $ perf annotate -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run
>>    Error: symbol 'vmx_vcpu_run' not present amongst the samples.
>>
>> builtin symbols work.
>>      
> Ah.  Did you reboot or unload/load the module between record and
> annotate time?  There is no support for that at the moment.
>    

No.  Still loaded and running.

-- 
error compiling committee.c: too many arguments to function

