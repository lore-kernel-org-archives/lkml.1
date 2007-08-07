Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXHGIw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXHGIw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbXHGIwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:52:51 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:60944 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbXHGIwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:52:50 -0400
Message-ID: <46B832D0.5030803@free.fr>
Date: Tue, 07 Aug 2007 10:52:32 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: Old -rt patches
References: <46B0B7A4.8060805@free.fr> <46B6E210.9090502@free.fr> <20070806144158.GA9309@linux.vnet.ibm.com>
In-Reply-To: <20070806144158.GA9309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

> John Sigler wrote:
> 
>> I wrote a Linux app where I need high-resolution timers. I went all the 
>> way and installed the -rt patch, which includes the -hrt patches, as far 
>> as I understand.
>>
>> Since I could not afford to change kernels with every new release, I 
>> decided to track the 2.6.20 branch (arbitrarily).
>>
>> At this point I'm using 2.6.20.7-rt8 (-rt8 was the last patch to the 
>> 2.6.20 branch). (I see 2.6.20 is already up to .15)
>>
>> I see a lot of patches going into the -rt patch, but development moved 
>> on to 2.6.21, then 2.6.22, and now 2.6.23, following mainline.
>>
>> I'm not a kernel hacker, so I don't claim to understand the patches, but 
>> the comments sound like a few bugs are fixed here and there. I can't 
>> tell whether these bugs also exist in previous kernels or only appeared 
>> in newer kernels. Even if I knew, I probably wouldn't have the expertise 
>> to back-port the patch.
>>
>> I'm seeing weird behavior in my app, when it has been running 2-4 days. 
>> The timers start to act out, and all hell breaks loose. Basically, I 
>> have no idea what's going on...
>>
>> My question is: is it possible that there is a bug in 2.6.20-rt8 that 
>> has been fixed in subsequent -rt patches (there's a 2.6.21.6-rt21 and a 
>> 2.6.22.1-rt9)? In other words, if I give 2.6.21.6-rt8 or 2.6.22.1-rt9 a 
>> spin, is it possible that my weird behavior disappears?
>>
>> I'm not saying that it's impossible for the bug to be in my app, but the 
>> app is small enough that I'm fairly confident there's no problem there.
> 
> Would you be willing to post your app so people could try to reproduce
> your bug?

Hello Paul,

I cannot provide the app "as is" (I fear the paranoid PHB would 
spontaneously combust). If time permits, I will try to make a small 
testcase to exhibit the problem.

Regards.
