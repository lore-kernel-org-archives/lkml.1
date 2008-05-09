Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYEIWsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYEIWsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYEIWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:48:37 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:34880 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbYEIWsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:48:36 -0400
Message-ID: <4824D4C0.10201@krogh.cc>
Date: Sat, 10 May 2008 00:48:32 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>	<20080507.141521.193714938.davem@davemloft.net>	<482498D5.9060008@krogh.cc>	<20080509.143229.174354251.davem@davemloft.net> <4824C936.9000103@krogh.cc> <4824CE43.8060203@hp.com>
In-Reply-To: <4824CE43.8060203@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
>> The number of contextswitches seems enourmous.. over 120.000 sometimes.
>> When transmitting around the same amount of data (4xgigabit bonded with
>> 802.3ad) 4x110MB/s the amount of contextswitches only reaches 3-4.000. I
>> have no idea if this has any relevance.
>>
>> Should this setup not be able to fill the pipe?
> 
> Into which slot was the Neptune inserted?  (sure will be nice to have 
> Alex Chiang's pci slot id patch in mainline one of these days :)
> 
> Is that slot x4, x8, x16?

I can find out excactly .. on monday. But shouldn't x4 be enough anyway?
wikipedia says 250MB/s pr. lane. And no slots is less than x4, so I
thought that it didn't matter to me.

> To which cpu(s) were the neptune's interrupts assigned? (grep <ethN> 
> /proc/interrupts)

Several

> Is the irqbalanced running?

Yes. I started by not running it, but saw that cpu 0 was saturated by
ksoftirqd

> Were any of the 16 CPUs in the system saturated during the test? (top 
> with all CPUs displayed)

Yes..
Cpu12 : 34.2%us,  5.9%sy,  0.0%ni,  0.0%id, 14.5%wa,  1.0%hi, 44.4%si, 
0.0%st

All others have idle time.

> Do you have/know of any diagrams showing the way the I/O slots are wired 
> to the rest of the system?

I havent dug into that. Probably naive, as I as, I expected som hardware
guys as Sun to have taken care of that, when I bought the recommended
10g card for their own server.

> Have you tried any tests without any filesystem involvement? 

no not yet. I'll try that.

-- 
Jesper
