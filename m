Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXHJEgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXHJEgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXHJEg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:36:28 -0400
Received: from mail.tmr.com ([64.65.253.246]:60811 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXHJEg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:36:28 -0400
Message-ID: <46BBEC37.5040900@tmr.com>
Date: Fri, 10 Aug 2007 00:40:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: rtc max frequency setting
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr> <46B5148E.50302@zytor.com>
In-Reply-To: <46B5148E.50302@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jan Engelhardt wrote:
>> Hi,
>>
>> with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
>> that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
>> general), I am missing this file. Where can I set the max-user-freq now, 
>> or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
>>
> 
> Qemu wants something like this too.  Both of these really want something
> else, which is a high-frequency userspace timer.
> 
> What is the best way to do that on modern kernels?
> 
/proc/sys/dev/hpet/max-user-freq? But I notice that some kernels provide 
both values (my 2.6.15, was where I looked), so maybe the rtc went away.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
