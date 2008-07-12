Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYGLIa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYGLIa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 04:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYGLIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 04:30:46 -0400
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:38222
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYGLIao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 04:30:44 -0400
Date: Sat, 12 Jul 2008 10:29:59 +0200 (CEST)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.LFD.1.10.0807090726200.686@bbs.intern>
Message-ID: <alpine.LFD.1.10.0807121025310.10748@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern> <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan> <alpine.LFD.1.10.0807090726200.686@bbs.intern>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-MailScanner-Information-wiesinger.com: Please contact the ISP for more information
X-MailScanner-wiesinger.com: Found to be clean
X-MailScanner-SpamCheck-wiesinger.com: not spam, SpamAssassin (score=-4.399,
	required 4.5, autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jul 2008, Gerhard Wiesinger wrote:

> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>
>>>>>> Hi Gerhard,
>>>> 
>>>> Please run:
>>>> 
>>>> smartctl -t short /dev/sdc
>>>> sleep 300
>>>> smartctl -t long /dev/sdc
>>>> 
>>>> Wait 2-3 hours or more and:
>>>> 
>>>> smartctl -a /dev/sdc
>>> 
>>> 
>>> I'm changing the disk one more time ...
>> 
>> Once you replace the disk please re-run the tests shown above and show us 
>> the output please.
>> 
>> How many SAMSUNG disks have you gone through, do they really fail that 
>> often?
>> 
>
> Hello Justin!
>
> Setup Power suppply:
> sda-sdd are on the same power supply cable, sde, sdf are on a second one.
>
> I changed the disk to a new SAMSUNG disk and the first raid resync did NOT 
> work and I had 1 reallocated sector ...
>
> Also the RMA guy at our very good computer store (http://www.ditech.at/) were 
> helpfull in changing the disks and he hates the SAMSUNG disks because of high 
> RMA rates ...
>
> But:
> smart checks were ok (details see below). The smart checks are shown as 
> aborted, but before running the next tests they were at "Completed without 
> error" (strange).
>
> Now sdc has it's own power cable and I'm running a raid resync now.
>
> Power supply is:
> ATX 385 Watt, ENERMAX PRO82+
>
> Load on power supply measured on 220V side with a true RMS Wattmeter:
> Power off: 6,5W
> Max seen at power up: 196W
> BIOS: 114,1W
> Linux idle: 92,0W
> 100% Disk I/O, 100% CPU load: 149,6W
> => Everything fine and as expected.
>
> I'll keep you up to date ...
>

Hello!

It looks like it works now without any problems:
*) Serveral RAID checks (once a day)
*) smartctl checks were fine
*) Only one reallocated sector
*) Writing the disk full with random data

So the possibilities for the fault are:
*) SATA power connector (most likely I would guess)
*) 4th disk is now ok
*) Other 220V power cable connector through the Wattmeter

Ciao,
Gerhard

--
http://www.wiesinger.com/
