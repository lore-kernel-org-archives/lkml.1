Return-Path: <linux-kernel-owner+w=401wt.eu-S1767334AbXECC3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767334AbXECC3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767340AbXECC3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:29:17 -0400
Received: from rtr.ca ([64.26.128.89]:3051 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767334AbXECC3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:29:16 -0400
Message-ID: <463948F8.5090907@rtr.ca>
Date: Wed, 02 May 2007 22:29:12 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both	of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>		 <463741F1.7050706@rtr.ca>	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca>	 <1178035058.5791.333.camel@localhost.localdomain> <46377055.2060605@rtr.ca>	 <1178092035.5791.349.camel@localhost.localdomain>	 <20070502010527.e64dcce9.akpm@linux-foundation.org>	 <1178120457.25504.17.camel@localhost.localdomain> <463910BF.9050103@rtr.ca> <1178145675.2340.28.camel@localhost.localdomain>
In-Reply-To: <1178145675.2340.28.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> ..
> I try to come up with something, but I'm travelling tomorrow, so it
> might be not before end of week.

Thanks, Thomas.

I believe we definitely want to nail this down before 2.6.22-final,
but there's a good workaround in the interim (CONFIG_DETECT_SOFTLOCKUP=y)
and we've got at least a couple of months 'till then.

I think I may have fiddled with the RTC config, so I'll compare with my
old config and see what changed.

Cheers
