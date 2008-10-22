Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbYJVDli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbYJVDli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYJVDla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:41:30 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:53588 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJVDla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:41:30 -0400
Message-ID: <48FEA0C5.5000802@tlinx.org>
Date: Tue, 21 Oct 2008 20:40:53 -0700
From: Linda Walsh <smartmontools@tlinx.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: re: Promise SATA-standby +selftest=hungdrive; Sil works...
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com> <48EABD07.6030506@tlinx.org> <48EABE8E.9070809@gmail.com> <48EBE263.8000500@tlinx.org> <48EBF7F7.8080908@gmail.com>
In-Reply-To: <48EBF7F7.8080908@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is with 2.6.26.5  (there are multiple other problems with 2.6.27[.0]).

The problem with the drive going "offline" doesn't happen with a
sil_sata(3124) controller -- so no need to unplug and replug...


I.e. when the drives are in standby, if smartd or a smartctl command
attempts to run a drive self-test (short), I get timeout errors from the
Promise controller (which hangs the sys if I try unplugging/replugging
the cable to the hung drive). 

The drives correctly spin up to speed and perform the short-test with
the sil controller.

It would seem there is a problem with the Promise controller or driver?


Tejun Heo wrote:
> Linda Walsh wrote:
>   
>> Tejun Heo wrote:
>>     
>>> Linda Walsh wrote:
>>>  
>>>       
>>>> Controller is a Promise TX4/300
>>>> Yeap.  After the drive goes offline, does unplugging and replugging
>>>> the power cable to the harddrive makes it come back?
>>>>     
>>>>         
>> ----
>>    No.  It hangs the computer. about 2-3 seconds after plugging the
>> drives back in.  Did it twice to verify it wasn't a fluke.  Verified
>> drives removed from /dev, then
>> plugged them back in -- was able to do about 1-2 ls commands on /dev, then
>> keyboard goes dead.
>>
>>    First time I tried unplugging the power cables and replugging --
>> that hung...
>> 2nd time tried unplugging a sata cable and replugging -- that hung too.
>>     
>
> Ah.. okay, so the controller went bonkers then.  Any chance you can
> shell out ~15 bucks and try a sil SATA controller?
>
>   
>>    Hopefully you won't need any more tests of this exact nature...? :-)
>>     
>
> Wasn't it fun and empowering?  :-P
>
>   

