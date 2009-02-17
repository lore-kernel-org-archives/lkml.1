Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZBQP24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZBQP24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBQP2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:28:45 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52106 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZBQP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:28:43 -0500
Message-ID: <499AD7A5.6060009@in.ibm.com>
Date: Tue, 17 Feb 2009 20:58:37 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: Next 17 : warn_slowpath() / powernowk8_cpu_init
References: <20090217203832.d6f2ef79.sfr@canb.auug.org.au> <499AD63B.5040608@in.ibm.com>
In-Reply-To: <499AD63B.5040608@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin P. Sant wrote:
> While booting next 17 kernel on a x86_64 box noticed the following
>
> powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 2218 
> processors (4 cpu cores) (version 2.20.00)
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1255 
> powernowk8_cpu_init+0x493/0xd22()
/proc/cpuinfo output
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 65
model name      : Dual-Core AMD Opteron(tm) Processor 2218
stepping        : 2
cpu MHz         : 2200.007
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 4400.01
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

Let me know if more information is required.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

