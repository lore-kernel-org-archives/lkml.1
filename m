Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXEMVJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXEMVJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXEMVJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:09:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXEMVJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:09:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] Freezing of kernel threads
Date: Sun, 13 May 2007 23:14:43 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
References: <200705122017.32792.rjw@sisk.pl> <200705132208.23254.rjw@sisk.pl> <alpine.LFD.0.98.0705131347550.6739@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705131347550.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132314.44688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 22:49, Linus Torvalds wrote:
> 
> On Sun, 13 May 2007, Rafael J. Wysocki wrote:
> > 
> > Besides, the problems with interdependencies that we've had recently are
> > related specifically to the CPU hotplug.  To be precise, they are related to the
> > CPU hotplug notifiers that try to stop kernel threads which may be frozen.
> > The other interdependencies don't lead to freezer-related problems.
> 
> Sure they do. We've always had interdependencies and freezer-related 
> problems. That's why PF_NOFREEZE exists in the first place.

Okay, we've already discussed that.  I was referring to the recent problems
and I should have added "at present" to the last sentence. :-)

> Claiming this is somehow CPU hotplug-related is disingenious, since the 
> freezer hasn't even been used for that historically, yet clearly we *do* 
> have the NOFREEZE stuff.
> 
> Those kernel threads tend to exists for a reason. 

Agreed.

Greetings,
Rafael
