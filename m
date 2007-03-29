Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXC2Lvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXC2Lvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXC2Lvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:51:51 -0400
Received: from smtpout.mac.com ([17.250.248.175]:49286 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbXC2Lvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:51:50 -0400
In-Reply-To: <200703291341.13172.ak@suse.de>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070328170159.7fc8c289.akpm@linux-foundation.org> <20070329005953.GA8764@linux-os.sc.intel.com> <200703291341.13172.ak@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7B0DEC32-4413-46CB-BB4D-DC6A1674F2EC@mac.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Date: Thu, 29 Mar 2007 07:51:15 -0400
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 29, 2007, at 07:41:12, Andi Kleen wrote:
>> ondemand is the biggest offender and the patch below reduces the  
>> number of interrupts by 50% or more (depending on HZ) on different  
>> test systems here.
>
> Cool!
>
>> Yes. There are quite a few other timers inside kernel that can be  
>> migrated. I will use timer_stats and track others and send in the  
>> patches soon.
>
> Longer term it might make sense to even expose this as a option to  
> user space. Maybe as a new timer in setitimer()? This might safe  
> power with "wiggling desktop applets" too.

Might also be useful to add an extra option to "top" to reduce the  
polling frequency if the system is otherwise idle.  A fixed 30-sec  
timer and a deferrable 1-sec timer or somesuch?

Cheers,
Kyle Moffett

