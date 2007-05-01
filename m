Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXEAQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXEAQbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXEAQbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:31:35 -0400
Received: from rtr.ca ([64.26.128.89]:2596 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbXEAQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:31:34 -0400
Message-ID: <46376B63.9080808@rtr.ca>
Date: Tue, 01 May 2007 12:31:31 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>		 <463741F1.7050706@rtr.ca>	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca> <1178033061.5791.314.camel@localhost.localdomain>
In-Reply-To: <1178033061.5791.314.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> I meant disable HPET via: hpet=disable on the commandline 
> 
>> Screenshots for that are available here:   http://rtr.ca/hrtimers/

hpet=disable fails, without the "switched to high resolution timer" message(s).
New snapshot of it now at the link above.

I also applied Tejun's early libata/SCSI race fix,
and that made no difference either.

Cheers
