Return-Path: <linux-kernel-owner+w=401wt.eu-S1766691AbXEBW32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766691AbXEBW32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766703AbXEBW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:29:28 -0400
Received: from rtr.ca ([64.26.128.89]:2319 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766691AbXEBW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:29:27 -0400
Message-ID: <463910BF.9050103@rtr.ca>
Date: Wed, 02 May 2007 18:29:19 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>	 <463741F1.7050706@rtr.ca> <1178027285.5791.307.camel@localhost.localdomain>	 <46374B1D.6050509@rtr.ca> <1178035058.5791.333.camel@localhost.localdomain>	 <46377055.2060605@rtr.ca> <1178092035.5791.349.camel@localhost.localdomain>	 <20070502010527.e64dcce9.akpm@linux-foundation.org> <1178120457.25504.17.camel@localhost.localdomain>
In-Reply-To: <1178120457.25504.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh crap.  It's back.

I don't know what's different from before,
but the system now locks up again exactly the same way,
even with the lock contention fix applied.

With or without CONFIG_PROVE_LOCKING=y in the config.

I've gotta get some work done here (this is my primary development machine),
so it's back to CONFIG_DETECT_SOFTLOCKUP=y for a while.

If anyone has a patch to dump out state/whatever just before that
last message that preceeds all lockups, then pass it along and
I'll queue it up for testing as soon as I can.

Cheers
