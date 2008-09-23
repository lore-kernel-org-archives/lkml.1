Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYIWP0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYIWP0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYIWP0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:26:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYIWP0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:26:17 -0400
Message-ID: <48D909E9.4090801@redhat.com>
Date: Tue, 23 Sep 2008 11:23:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>	 <48D81B5F.2030702@redhat.com>	 <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>	 <48D832B6.3010409@redhat.com>	 <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>	 <adaod2f649o.fsf@cisco.com>	 <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>	 <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>	 <48D86C38.9000407@redhat.com> <33307c790809222117w655894ffoce7950fb72b60e3f@mail.gmail.com>
In-Reply-To: <33307c790809222117w655894ffoce7950fb72b60e3f@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Bligh wrote:
>>            log event c
>> hit event b
>> log event b
>>            log event d
>>
>> so, I think if we really need to order events, we have to stop
>> irq right after hitting an event.
> 
> How could you fix that in any practical way?

In that case, I think it's easy to know that event c is irq
related event by checking source code. :-)
And practically, in most cases, I think we can presume what
happened by event arguments and subsequent events.

Anyway, since there must be a delay between hitting event(and
as linus said, happening event) and logging it, I think buffering
mechanism itself should focus on ensuring only writing and
reading order.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


