Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbXEADdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbXEADdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXEADdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:33:18 -0400
Received: from rtr.ca ([64.26.128.89]:4744 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbXEADdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:33:17 -0400
Message-ID: <4636B4F9.6040406@rtr.ca>
Date: Mon, 30 Apr 2007 23:33:13 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>	 <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>	 <463685BD.8010604@rtr.ca> <1177978391.12796.301.camel@imap.mvista.com>
In-Reply-To: <1177978391.12796.301.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> 
> I'm interested in which clocksource is getting used, which is in the
> boot log.

Well then, send me a patch that dumps that information out just before it locks up.
We know (first post in this thread) that the lockup occurs just after
these two messages:

  "switched to high resolution mode on cpu 1"
  "switched to high resolution mode on cpu 0"

So just dump out anything else you need to see at the same time,
and it'll still be on my screen when the darned thing locks up.

Simple, eh.  We both get to run around a treadmill this way.  ;)
