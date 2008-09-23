Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYIWAHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYIWAHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYIWAG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:06:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYIWAG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:06:57 -0400
Message-ID: <48D83295.7020301@redhat.com>
Date: Mon, 22 Sep 2008 20:04:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Darren Hart <darren@dvhart.com>
CC: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <48D7F5E8.3000705@redhat.com>	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>	 <48D81B5F.2030702@redhat.com> <e17d46420809221611yeb107a1hd395770e4915b20@mail.gmail.com>
In-Reply-To: <e17d46420809221611yeb107a1hd395770e4915b20@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

Darren Hart wrote:
> On Mon, Sep 22, 2008 at 3:25 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>>> One thing that I think is still important is to have a unified timestamp
>>> mechanism on everything, so we can co-ordinate different things back
>>> together in userspace from different trace tools, so I intend to keep
>>> that at a lower level, but I think you're right that the event id, etc can
>>> move up into separate layers.
>> I'm not so sure that the unified 'timestamp' must be required by all tracers.
>> If you just need to merge and sort per-cpu data, you can use an atomic
>> sequential number for it.
>> IMHO, the unified 'timestamp' would better be an option, because some
>> architectures can't support it. I think preparing timestamp-callback
>> function will help us.
>>
> 
> There have been several posts on the timestamp for the events.  From a
> real-time perspective, this timestamp will be a very important datapoint for
> each event, and the more accurate/higher resolution the better.  Some thoughts.

Sure, I know the precise timestamp is required for real-time sensitive
tracers. however, there are some other cases. for example debugging,
we don't need timestamps, but just want to know the order of events. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

