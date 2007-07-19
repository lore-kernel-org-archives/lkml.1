Return-Path: <linux-kernel-owner+w=401wt.eu-S936219AbXGSOlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936219AbXGSOlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXGSOln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:41:43 -0400
Received: from gw.goop.org ([64.81.55.164]:58703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbXGSOlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:41:42 -0400
Message-ID: <469F77F0.8040407@goop.org>
Date: Thu, 19 Jul 2007 07:40:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu>
In-Reply-To: <20070719143528.GA8278@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> How reliable does it need to be?  All we need is to measure "about 10 
>> seconds"; if we can't get that out of it, how can it be good for 
>> anything else?
>>     
>
> sched_clock(), as its name suggests it, is meant for the scheduler's 
> use. The scheduler generally only needs to measure time when the CPU is 
> busy - not across idle periods. So sched_clock() can (and will) break 
> across certain types of ACPI idle methods.
>   

Doesn't that mean it will mis-measure process idle times?  Is that a
problem?

    J
