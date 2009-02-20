Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZBTRHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZBTRHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZBTRGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:06:55 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:46420 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBTRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:06:54 -0500
Message-ID: <499EE32B.1040800@cfl.rr.com>
Date: Fri, 20 Feb 2009 12:06:51 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com>
In-Reply-To: <20090220160843.GF4834@alberich.amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> On Fri, Feb 20, 2009 at 10:43:03AM -0500, Mark Hounschell wrote:
>> Andreas Herrmann wrote:
>>> On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
>>>> Borislav Petkov wrote:
>>>>> On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
>>>>>> Andreas Herrmann wrote:
>>>>>>> Hi Mark,
>>>>>>>
>>>>>>> Can you please provide us output of lspci -vvxxx.
>>>>>>> (Please run this as root.)
>>>>>>>
>>>> Attached...
>>>>
>>>>
>>>>>>> Furthermore you can try booting your 1000HZ kernel
>>>>>>> with following kernel command lines:
>>>>>>>
>>> Thanks for trying this out.
>>> But nothing suspicious found. I.e. timer/hpet interrupt is enabled
>>> and its routing seems to be ok.
>>>
>>> Here's one more check that's worth trying: In one of your logs I've
>>> seen that HPET id reports 3 timers but later on 4 timers were detected
>>> for HPET.
>>>
>>> To check what's going on I'd like to see the HPET configuration in the
>>> course of booting your system.  Please apply attached patch and boot
>>> with hpet=debug -- both with 250HZ and with 1000HZ -- and provide dmesg
>>> output.
>>>
>>>
>> Here is the short 1000Hz bootlog. I'm afraid non of your debug output made it
>> out however.
> 
> Sigh.
> 
>> I thought it was because it just wasn't getting that far but
>> looking at the 250Hz log I don't see any there either???
> 
> 
>> The patch applied (with fuz) to both kernel sources and I built/installed them
>> from clean. I don't find any messages starting with "hpet:" in either trace???
> 
> Your 250HZ kernel was built on Feb, 2nd, right?
> So the patch wasn't applied I guess, no?
> 

The patch was applied. These 2 kernels were built from "clean" at the same time.

>> Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
>> (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #7 SMP PREEMPT Fri Feb
>> 20 09:01:29 EST 2009
> 
> I assume the patch was aplied.
> 

Yes it was.

>> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1
>> 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux)
>> ) #7 SMP PREEMPT Fri Feb 2 0 09:01:54 EST 2009
> 
                             ^
                             |

Look closer it was built Feb 20 09:01:53. Not Feb 2 0 09:01:53.
There is a space between the 2 and 0 because of a minicom linewrap I guess.


> Here I doubt that's the right kernel -- at least it was not built today.
> Can you please double check this.
> 

My double check is correct. both these kernels were built this morning from
"clean" after your patch was applied.


I will do it all again from scratch if you wish.

Not a problem. I am at your disposal. I'm not ignorant when it comes to building
and installing kernels.

Standing by.
Mark
