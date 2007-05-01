Return-Path: <linux-kernel-owner+w=401wt.eu-S1423495AbXEANfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423495AbXEANfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423505AbXEANfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:35:13 -0400
Received: from rtr.ca ([64.26.128.89]:2129 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423495AbXEANeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:34:44 -0400
Message-ID: <463741F1.7050706@rtr.ca>
Date: Tue, 01 May 2007 09:34:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both	of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca> <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
In-Reply-To: <4637419D.8010303@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Thomas Gleixner wrote:
>> Mark,
>>
>> On Mon, 2007-04-30 at 20:02 -0400, Mark Lord wrote:
>>> When it does boot with the modified .config file,
>>> the log looks like the one attached to this email.
>>
>> Can you please send me the output of /proc/timer_list ?
> 
> Timer List Version: v0.3
> HRTIMER_MAX_CLOCK_BASES: 2
> now at 3232363876949 nsecs
...

Oh, in case it matters any:
that /proc/timer_list is from the system with CFS-V7 also patched in.

-ml
