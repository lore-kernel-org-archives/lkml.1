Return-Path: <linux-kernel-owner+w=401wt.eu-S1764450AbXHHWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764450AbXHHWyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbXHHWyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:54:35 -0400
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:63864 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759536AbXHHWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:54:34 -0400
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e39372e36347c3149497551442d3030303731362d334f7c3131383636313336
	3733
Message-ID: <46BA49A7.5040608@snafu.de>
Date: Thu, 09 Aug 2007 00:54:31 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange> <46BA320E.1030608@snafu.de> <Pine.LNX.4.60.0708082323420.6767@poirot.grange> <46BA3DF5.4050201@snafu.de> <Pine.LNX.4.60.0708090041160.6767@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708090041160.6767@poirot.grange>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 9 Aug 2007, Oncaphillis wrote:
>>   I hope I found the the misconfigured part. I didn't look
>>   at /etc/inittab. It opens a getty on /dev/ttyS0. That
>>   might do the trick. Have to recompile my kernel right now with
>>   standard config to check this out.
> 
> Hm, for that you don't have to recompile the kernel... unless you modified 
> it before, of course. Just change your inittab and reboot.

   Oh I know... I just played around with the kernel config
   to solve the problem and ended up with a kernel that didn't
   boot at all..

> 
>>   Well ... it doesn't seem to need the daemons but at least
>>   the kuro_boot  script or something similar has to be executed
>>   once sending the right init strings to the AVR or your system
>>   reboots after a few minutes at least on my box.
> 
> No, shouldn't be needed either. You should get a string in dmesg like 
> "linkstation: disarming the AVR watchdog:", and the watchdog should be 
> off. Just take the original .dts, unmodified kernel sources and close 
> enough to original (arch/powerpc/configs/linkstation_defconfig) .config 
> and it should work.
> 

  Thanks again...


> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

