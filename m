Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXJMMDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXJMMDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXJMMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:03:22 -0400
Received: from maxwell.spina.si ([193.77.104.223]:64235 "EHLO maxwell.spina.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXJMMDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:03:21 -0400
Message-ID: <4710B407.8070101@kanardia.eu>
Date: Sat, 13 Oct 2007 14:03:19 +0200
From: Rok Markovic <kernel@kanardia.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu> <470FD96A.8040505@kanardia.eu> <20071013055922.GB26370@elte.hu> <47109008.5090405@kanardia.eu> <20071013094142.GA16098@elte.hu>
In-Reply-To: <20071013094142.GA16098@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Good news (I hope). With kernel option maxcpus=1, I can not get
a lock, so the system is stable and running. Where could be a problem?

Best regards,
Rok
 

Ingo Molnar wrote:
>> Hi
>>
>> I have recompiled kernel with OPROFILE disabled. I am sending in 
>> attachment /proc/interrupts (i ran it 3 times with 2 sec delay) and 
>> netconsole log. Lockup in the lock is software made with ./lockup. The 
>> kernel still locks 4-5minutes after boot without any further messages 
>> (waited more than 2 minutes). Any ideas?
> 
> no good ideas :-( I suspect this one:
> 
>   [  185.600900] hdc: lost interrupt
> 
> was a side-effect of lockup.c too?
> 
> does the lockup go away if you boot with maxcpus=1?
> 
> 	Ingo
> 
> 

