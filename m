Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZIVLv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZIVLv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZIVLv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbZIVLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:51:56 -0400
Message-ID: <4AB8BA37.4010305@redhat.com>
Date: Tue, 22 Sep 2009 14:51:19 +0300
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
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
In-Reply-To: <1253620041.13917.24.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 02:47 PM, Mike Galbraith wrote:
>
> Hm, must me a problem with parsing then.  If you add -v -v to the
> command line it'll spit out debug data.  For vmx_vcpu_run you should see
> a line like so if the module was parsed.
>
> new symbol: ffffffffa0065a49 [00000466]: ahci_interrupt, hist: (nil), obj_start: 0x2a49
>
> 	-Mike
>
>    

$ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  | 
grep vmx_vcpu_run
new symbol: ffffffffa006f596 [0000dead]: vmx_vcpu_run    [kvm_intel], 
hist: (nil), obj_start: (nil)
  ffffffffa006f596-ffffffffa006fb73 vmx_vcpu_run    [kvm_intel]
  Error: symbol 'vmx_vcpu_run' not present amongst the samples.

Looks like internal confusion.

-- 
error compiling committee.c: too many arguments to function

