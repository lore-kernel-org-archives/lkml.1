Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYLGD0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYLGD0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 22:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYLGDZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 22:25:56 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:35855 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLGDZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 22:25:56 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=kFPgB9Ftasl8DnGjXzAA:9 a=1rYEFFzTMUBjxAUXhRZ2zB0iQfwA:4 a=ybilIN7zEmwA:10 a=6lB08MFujYwA:10
Message-ID: <493B4242.1040202@shaw.ca>
Date: Sat, 06 Dec 2008 21:25:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com> <493AE770.5030507@shaw.ca> <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com> <493AF2EA.4030601@shaw.ca> <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
In-Reply-To: <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> On Sat, Dec 6, 2008 at 10:47 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>> Giangiacomo Mariotti wrote:
>>> On Sat, Dec 6, 2008 at 9:58 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>>>> Giangiacomo Mariotti wrote:
>>>>> Hi everyone,
>>>>> Mcelog just logged on my new Intel I7 920 (on Linux 2.6.27.8) this :
>>>>> MCE 0
>>>>> HARDWARE ERROR. This is *NOT* a software problem!
>>>>> Please contact your hardware vendor
>>>>> CPU 0 BANK 6 MISC 202d ADDR ffeef740
>>>>> MCG status:
>>>>> MCi status:
>>>>> Error overflow
>>>>> Uncorrected error
>>>>> MCi_MISC register valid
>>>>> MCi_ADDR register valid
>>>>> Processor context corrupt
>>>>> MCA: Generic CACHE Level-2 Data-Write Error
>>>>> STATUS ee0000000100014a MCGSTATUS 0
>>>>>
>>>>> I'm reporting this here, because I found in the Intel I7 Technical
>>>>> Specification November 2008 update that something which seems very
>>>>> similar is in fact an erratum. So my question is : Is there any way
>>>>> for me to verify that my problem is due to one of those errata,instead
>>>>> of a broken hardware(if we don't want to consider all those errata as
>>>>> broken hardware)? I'm also reporting this because I thought it may be
>>>>> useful to signal that(if actually due to those errata) these problems
>>>>> actually occur, so it may be useful to find workarounds in the kernel
>>>>> to not scare to death poor Linux users!
>>>> Which erratum are you talking about? I don't see one in that document
>>>> that
>>>> would match this case..
>>>>
>>> Well, the first one seems very similar, even if it talks about a dtlb
>>> error instead of cache error. But sure,being similar doesn't mean too
>>> much. Number 52 seems similar too. I guess I should just give up and
>>> admit that my hardware is broken!
>>>
>> The first one is just indicating that if a DTLB error occurs the overflow
>> bit may be set incorrectly. It's not a false error though. The AAJ52 erratum
>> would only occur immediately after powerup or wake from sleep states.
>>
> The mce actually got logged once immediately after powerup and never
> more. Is that reasonable? A cache error which happens just once after
> boot?

The erratum refers to an internal parity error, not an L2 cache write error.

If it only happened once then who knows, could be a cosmic ray or 
something.. but if it happens again it sounds like you likely have a bad 
CPU.
