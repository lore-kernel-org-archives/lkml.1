Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbYD2Rme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbYD2Rme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760466AbYD2RiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:38:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45079 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933170AbYD2RiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:38:04 -0400
Message-ID: <48175CF8.4010105@sgi.com>
Date: Tue, 29 Apr 2008 10:38:00 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: fix remove cpu_pda table patch
References: <20080428210906.348866000@polaris-admin.engr.sgi.com> <20080428214541.GA16153@elte.hu>
In-Reply-To: <20080428214541.GA16153@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> [Ingo - please replace "PATCH 07/11" with this one.]
>>
>>     *	Remove 544k bytes from the kernel by removing the boot_cpu_pda
>> 	array from the data section and allocating it during startup.
>>
>> 	Fixed panic in setup_per_cpu_areas when HOTPLUG_CPU not set.
>>
>> For inclusion into sched-devel/latest tree.
> 
> sched-devel.git randconfig testing found another crash with your queue:
> 
> [    0.111060] Brought up 1 CPUs
> [    0.111986] Total of 1 processors activated (4022.73 BogoMIPS).
> [    0.112987] Testing NMI watchdog ... <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> [    0.114982] IP: [<ffffffff8180d4a0>] check_nmi_watchdog+0xb0/0x210
> [    0.114982] PGD 0
> [    0.114982] Oops: 0000 [1] SMP
> [    0.114982] CPU 0
> [............]
> 
>  http://redhat.com/~mingo/misc/config-Mon_Apr_28_23_25_25_CEST_2008.bad
>  http://redhat.com/~mingo/misc/log-Mon_Apr_28_23_25_25_CEST_2008.bad
> 
> 	Ingo

Hi Ingo,

I need a bit more information on your hardware configuration.  Building a
kernel with the above config file started up fine on both the Intel and AMD
boxes.

Based on the above output it looks like it might be a UP machine?  

Thanks,
Mike 
