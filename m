Return-Path: <linux-kernel-owner+w=401wt.eu-S2992766AbXCBXtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992766AbXCBXtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992771AbXCBXtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:49:51 -0500
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:35735 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992766AbXCBXtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:49:50 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 18:49:50 EST
Message-ID: <45E8B6A8.3020307@earthlink.net>
Date: Fri, 02 Mar 2007 18:43:36 -0500
From: Dan Gilliam <precambrian_critter@earthlink.net>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <e5ab0f710703020009u2b94fb72ja51e85b8b90eaba0@mail.gmail.com>
In-Reply-To: <e5ab0f710703020009u2b94fb72ja51e85b8b90eaba0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: d39f7ddaa7b5749bc8ad50643b1069f8239a348a220c2609bcd3291ba6adcbad78d2b56f7e9b6bfda7ce0e8f8d31aa3f350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.16.237.63
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> 2007/2/22, Robert Hancock <hancockr@shaw.ca>:
>>
>> I believe it runs on suspend, but we don't run that code on normal
>> shutdown, do we?
>>
>> Tejun Heo had a patch for sd that could (optionally) trigger a START
>> STOP UNIT command to spin the disk down after synchronizing the cache
>> before shutdown, but I haven't heard anything of it lately..
>>
>>
>
> Was this?
> http://www.nabble.com/(fwd)--PATCH--sd:-implement-stop_on_shutdown-t3049703.html 
>
>
> Not ready for inclusion yet? Tomorrow i'll give it a try, hoping it
> will apply to my conf. My actually shutdown procedure is to reboot on
> windows Xp and shutdown from there...
>
Hi, I just wanted to say that I'm another user having this issue.  I 
have a Toshiba M55-S3314 which is also making the same noise on 
shutdown.  I have heard it from Ubuntu 5.04 on to Feisty Fawn Herd 4 
(which is using the 2.6.20-9 kernel).  I had installed the newest 
version of Sidux the other night, with the 2.6.20 kernel, and it didn't 
seem to do it.  But then I tried it with Feisty, and at first, it didn't 
do it.  Then I suspended the unit, and it came back fine; then I 
hibernated the unit; it came up ok, but after that, it's making the 
noise again every time.  So I have no idea what's causing this.

I hope that somebody can figure this one out...for the first time since 
1998, I can't use linux on my machine! :-(  I can't afford to sacrifice 
my hard drive...  I'm not a programmer, but I'll be more than happy to 
try out stuff if anybody wants me to, or give logs or whatever.  Just 
tell me what you want and how to get it!

Thanks,
Dan
