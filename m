Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXIHRnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXIHRnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXIHRnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:43:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:43534 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXIHRnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:43:31 -0400
Message-ID: <46E2DF74.7040307@tmr.com>
Date: Sat, 08 Sep 2007 13:44:20 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: James Corey <ploversegg@yahoo.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, Adrian Bunk <bunk@stusta.de>,
       Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com>
In-Reply-To: <782111.42803.qm@web90413.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Corey wrote:
> --- Stephen Hemminger
> <shemminger@linux-foundation.org> wrote:
> 
>> On Sun, 29 Jul 2007 21:01:30 -0600
>> Rob Sims <lkml-z@robsims.com> wrote:
>>
>>> On Thu, Jul 26, 2007 at 06:57:01PM +0200, Adrian
>> Bunk wrote:

>> The only known outstanding problems on 2.62.22.6 of
>> sky2 are:
>>  * problems with fibre PHY based systems
>>  * suspend/resume issues, missing multicast
>> reinitalization, etc.
>> The previous stability problems have been addressed.
> 
> I pretty much agree with everything said, including 
> the part about the sky2 people working hard on it. I
> have noticed several bugs fixed recently in the driver
> source.
> 
> However, it really DOES lock up under load. I even 
> tried 2.6.23-rc4 and the absolute latest version of
> the
> driver and it still locks up, as in
> 
> eth1: hw csum failure.
> 
I checnged from the sk98lin to the previous driver Adrian said was the 
"right one," skge IIRC. Then he started pushing sky2, and I tried that. 
Like you I get hangs, but unlike you the system doesn't hang, just the 
NIC. No errors, warnings, and reboot fixes it. Acts as if the cable were 
pulled.

That was with 2.6.22.5 (or so), dropped back to an old kernel with 
sk98lin, previously had uptimes in three digit days. Up for a week or so 
now.

Haven't tried later kernels, don't intend to, while no network is really 
secure, it not really useful.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
