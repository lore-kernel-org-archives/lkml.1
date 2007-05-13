Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbXEMUu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbXEMUu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbXEMUuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:50:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbXEMUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:50:21 -0400
Date: Sun, 13 May 2007 13:49:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <200705132208.23254.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705131347550.6739@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl> <20070513083357.GA12985@in.ibm.com>
 <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
 <200705132208.23254.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 May 2007, Rafael J. Wysocki wrote:
> 
> Besides, the problems with interdependencies that we've had recently are
> related specifically to the CPU hotplug.  To be precise, they are related to the
> CPU hotplug notifiers that try to stop kernel threads which may be frozen.
> The other interdependencies don't lead to freezer-related problems.

Sure they do. We've always had interdependencies and freezer-related 
problems. That's why PF_NOFREEZE exists in the first place.

Claiming this is somehow CPU hotplug-related is disingenious, since the 
freezer hasn't even been used for that historically, yet clearly we *do* 
have the NOFREEZE stuff.

Those kernel threads tend to exists for a reason. 

			Linus
