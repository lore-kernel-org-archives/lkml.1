Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXEAQwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXEAQwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXEAQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:52:40 -0400
Received: from rtr.ca ([64.26.128.89]:1900 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbXEAQwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:52:40 -0400
Message-ID: <46377055.2060605@rtr.ca>
Date: Tue, 01 May 2007 12:52:37 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>		 <463741F1.7050706@rtr.ca>	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca> <1178035058.5791.333.camel@localhost.localdomain>
In-Reply-To: <1178035058.5791.333.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 2007-05-01 at 10:13 -0400, Mark Lord wrote:
>> Of possible interest is that the bottom of the 25line screen capture
>> differs somewhat from the 50line capture.. see for yourself.
>> This is 100% consistent from boot to boot.
>>
>> Using CONFIG_DETECT_SOFTLOCKUP=y eliminates the problem,
>> so that's really got to be a huge clue, somehow ?
> 
> I twisted my brain, why the watchdog thread might change the problem and
> I think I have a rough idea of the scenario. 
> 
> Can you apply the following patch, which prints out the CPU on which the
> kernel messages are generated and upload the screenshot when the hang
> happens ? Oh, please enable CONFIG_PRINTK_TIME or add "time" to the
> kernel commandline.

Done, and done.
And I managed to capture more of the boot messages, too.
This new capture is in the "sequence" subdir at the previous link.

Cheers
