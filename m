Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYCCNle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYCCNle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYCCNl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:41:26 -0500
Received: from mx2.compro.net ([216.54.166.4]:42191 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYCCNl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:41:26 -0500
X-IronPort-AV: E=Sophos;i="4.25,438,1199682000"; 
   d="scan'208";a="1800240"
Message-ID: <47CBFED1.7090903@compro.net>
Date: Mon, 03 Mar 2008 08:36:17 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jon Masters <jonathan@jonmasters.org>, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
References: <47BD6802.60604@cfl.rr.com>  <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>  <47BD7D09.9050106@compro.net>  <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com> <1204518711.22885.68.camel@perihelion> <Pine.LNX.4.58.0803030820580.20684@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0803030820580.20684@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Sun, 2 Mar 2008, Jon Masters wrote:
>> On Thu, 2008-02-21 at 10:08 -0500, Steven Rostedt wrote:
>>> On Thu, 21 Feb 2008, Mark Hounschell wrote:
>>>>> To prove this is the problem, boot with noapic in the kernel command line.
>>>>> 1) the problem should disappear.
>>>>> 2) (I'm betting) you see that the eth and EMU10K1 share the same
>>>>>    interrupt line.
>>>>>
>>>> Yep, you were right. They do share the same IRQ and the problem does go away.
>>>> Unfortunately  I can't run this machine with noapic. I need irq affinity.
>>>>
>>> Thanks for verifying. OK, I'll see if I can get the workaround on i386.
>> What's the situation with this one? Want me to look at it?
> 
> Jon,
> 
> The board Mark has may just be some cheap hardware. It would be great
> that RT would work on all boxes, but I'm not sure we want to spend time on
> "broken-by-design" hardware while there's bigger fish in the sea to catch.
> 
> The current workaround is just use noapic, although I do understand
> that's not good enough for Mark. But I'm sure Mark has other hardware
> he could use ;-)
> 
> -- Steve
> 
> 
Steve is correct. I have plenty of other choices. Steve, you mentioned, a "work around"
is in -rt3. My only concern is does the current "work around" for other hardware really 
work or may I see this again with other "non cheap" hardware? 

Is there a known list of hardware this problem is seen on?

Thanks
Mark
