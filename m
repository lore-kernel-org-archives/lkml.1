Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYJAPKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYJAPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYJAPJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:09:58 -0400
Received: from mail.tmr.com ([64.65.253.246]:50376 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYJAPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:09:57 -0400
Message-ID: <48E3929E.7060501@tmr.com>
Date: Wed, 01 Oct 2008 11:09:18 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080925 Fedora/1.1.12-1.fc9 pango-text SeaMonkey/1.1.12
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Gwendal Grignou <gwendal@google.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>	 <alpine.DEB.1.10.0809220404400.18908@p34.internal.lan>	 <5A4A9A3B0AAA4A20A33BC2D578F5F75F@909927SOSLA>	 <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>	 <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>	 <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>	 <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>	 <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>	 <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan> <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com> <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
In-Reply-To: <48E08E2D.6050905@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Bill Davidsen wrote:
>   
>> Gwendal Grignou wrote:
>>     
>>> About ata1:0 problem, as reported in the bugzilla bug: I would try to
>>> disable NCQ to see if it helps. Your disks firmware might not fully
>>> support it.
>>>
>>> You can either add the parameter "libata.force=noncq" when loading
>>> your kernel, or set queue_depth to 1 for all the Seagate drives behind
>>> the Marvell MV88SX6081 controller.
>>>
>>> About ata5:0 , someone - in user space probably - is trying to do a
>>> SMART ENABLE operation, but the device ignores it. I don't know which
>>> device you are using, but I assume it does not support ATA SMART
>>> feature set. Timeout is an acceptable but not a nice way to answer, a
>>> cancel would have been better; check if there is a firmware upgrade
>>> for your device.
>>>   
>>>       
>> You certainly called the SMART issue, I was wondering why a new
>> distribution install on some older hardware was getting all the errors,
>> clearly the Fedora "smartd" doesn't check SMART capability before trying
>> to enable the feature. Oddly the drive on which I see this does reply to
>> SMART requests, so the firmware must be "semi-functional." Not a
>> problem, in my case the drive is just used for testing handling of hot
>> swap, and has no data of any value.
>>     
>
> Can you post full kernel log including the boot messages and the error
> messages?  Also, please attach the output of hdparm -I on the drive
> which fails the smart command.
>   

Belatedly, the drive was retired after I got thinking about it, I'm just 
calling it an old bad drive and leaving it at that. I'm not goinf to 
re-install a dubious 20GB drive, it's out of the hot-swap carrier, 
cleared with dban, and in the recycle bin. You seem to have far better 
examples of the issue, so I don't feel I would hold up progress. :-)
> (cc'ing Bruce, hi!) Bruce, this is the second report I see about drive
> timing out SMART ENABLE OPERATIONS.  Does anything ring a bell?
>
> Thanks.
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


