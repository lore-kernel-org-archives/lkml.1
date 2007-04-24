Return-Path: <linux-kernel-owner+w=401wt.eu-S1161762AbXDXNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161762AbXDXNZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161763AbXDXNZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:25:31 -0400
Received: from [70.254.190.220] ([70.254.190.220]:57653 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161762AbXDXNZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:25:30 -0400
Date: Tue, 24 Apr 2007 13:25:30 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq default governor
In-Reply-To: <6bffcb0e0704240607s2e9b308dx448b5f477b8325e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704241320080.25153@server.thyself>
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself> 
 <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com> 
 <Pine.LNX.4.64.0704241235560.25153@server.thyself> 
 <6bffcb0e0704240550x2c47cd1ap8101a9b0db5c6c7d@mail.gmail.com> 
 <Pine.LNX.4.64.0704241252410.25153@server.thyself>
 <6bffcb0e0704240607s2e9b308dx448b5f477b8325e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Michal Piotrowski wrote:
> On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
>>  On Tue, 24 Apr 2007, Michal Piotrowski wrote:
>> 
>> >  On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
>> > >   On Tue, 24 Apr 2007, Michal Piotrowski wrote:
>> > > 
>> > > >   Hi William,
>> > > > 
>> > > >   On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
>> > > > >    Question: is there some reason that kconfig does not allow for
>> > > > >    default
>> > > > >    governors of conservative/ondemand/powersave?
>> > > > 
>> > > >   Performance?
>> > > > 
>> > > > >    I'm not aware of any reason why one of those governors could not 
>> > > > >    be
>> > > > >    used
>> > > > >    as default.
>> > > > 
>> > > >   My hardware doesn't work properly with ondemand governor. I hear
>> > > >   strange noises when frequency is changed.
>> > > > 
>> > > 
>> > >   That doesn't mean it isn't working, though.
>> > 
>> >  I didn't say that cpufreq ondemand is broken. It's a hardware problem.
>> > 
>> > >   I here weird noises if the cpu
>> > >   is clocked anywhere from 333MHz to 1GHz (sounds like an RD-D2 beeping
>> > >   noises in ultra high pitch?)
>> > 
>> >  Yes, something like that.
>>
>>  Is it actually "not working" though, even at the hardware level?
>
> It works, but for me this sounds are very weird ;)
>
>>  To my
>>  knowledge those noises are normal, and aren't even signs of a harware
>>  problem. I believe it is the natural result of changing frequencies at any
>>  time. If you change frequencies, especially in the low end of available
>>  frequencies, you should hear a very brief noise. A governor such as
>>  ondemand, which is rapidly switching the frequency from say, 333 MHz to
>>  2.66 GHz, is likely to make this much more noticable.
>
> Ok, it might be normal behavior. I might be wrong, but IMO users
> prefer speed and no strange sounds as default setting.

I agree! My suggestion, however, is that if they do want a different 
scheduler as the default, they can choose one.

There are some cases in which this could be very useful. A couple examples 
would be the processor with poor cooling that overheats easily, or a 
laptop with a poor battery.

However, on second thought with regards to Kconfig, would it be feasible 
to have performance always be the default, unless a 
"cpufreqgov=conservative" arguement was specified on the command line?

This would be less susceptible to users complaining that their cpu is 
chirping all of a sudden.

William Heimbigner
icxcnika@mar.tar.cc
