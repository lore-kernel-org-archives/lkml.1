Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbXCRWO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbXCRWO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXCRWO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:14:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344AbXCRWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:14:27 -0400
Message-ID: <45FDB6E8.5020303@redhat.com>
Date: Sun, 18 Mar 2007 18:02:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de, Stable Kernel Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>	 <1173817985.13341.120.camel@localhost.localdomain>	 <1173866413.13341.154.camel@localhost.localdomain>	 <20070316124313.9f0afc05.akpm@linux-foundation.org>	 <1174079120.13341.286.camel@localhost.localdomain>	 <45FDAC3B.6000202@redhat.com>	 <1174253579.13341.477.camel@localhost.localdomain>	 <45FDB4C9.5030103@redhat.com> <1174255487.13341.480.camel@localhost.localdomain>
In-Reply-To: <1174255487.13341.480.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sun, 2007-03-18 at 17:53 -0400, Chuck Ebbert wrote:
>>>> Just to be clear: this replaces the earlier patch, right?
>>> This replaces the fix Andrew did.
>>>
>>> http://marc.info/?l=linux-kernel&m=117407812411997&w=2
>>>
>> Right, but is the original "Prevent DOS" patch from you still needed?
>> Or did Andrew's patch replace that one, and now this replaces his?
> 
> The original patch is still needed - it handles the problem in the first
> place.
> 
> I missed to compile it for 32bit and Andrew did a fix, which I replaced.

Ah, OK, and both of those are now in the queue for 2.6.20-stable.


