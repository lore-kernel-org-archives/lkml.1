Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbXHCHs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbXHCHs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXHCHsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:48:21 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:57333 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXHCHsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:48:20 -0400
Message-ID: <46B2DD85.2030100@free.fr>
Date: Fri, 03 Aug 2007 09:47:17 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-rt-users@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       questions@lists.ntp.org
Subject: Re: System clock frequency offset changes drastically across reboots
References: <46A9DD7A.80104@free.fr> <46AD9A74.8070302@free.fr>
In-Reply-To: <46AD9A74.8070302@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Expanding recipients list to include NTP mailing list ]

> John Sigler wrote:
> 
>> I'm using 2.6.20.7-rt8 on a P3.
> 
> (But some ntpd users have reported the problem with mainline kernels and 
> different versions.)
> 
>> I've noticed that the frequency offset of my system clock (computed 
>> either by ntpd, or by hand) changes drastically across reboots.
>>
>> By drastically, I mean +/- 60 ppm every time I reboot.
>>
>> Apparently this is caused by some imprecision in the frequency 
>> estimation done in calculate_cpu_khz() (arch/i386/kernel/tsc.c)
>>
>> My brutally crude work-around was to skip the computation altogether 
>> and hard-code the "correct" value for cpu_khz.
>>
>> http://linux.kernel.free.fr/cpu_khz.adlink
>>
>> Has this issue been investigated more thoroughly by other users?

Is there, perhaps, more appropriate a forum to discuss such matters?

Regards.

