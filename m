Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYINRDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYINRDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYINRDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:03:00 -0400
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:52823 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYINRC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:02:59 -0400
Date: Sun, 14 Sep 2008 13:02:57 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
In-reply-to: <d9def9db0809140838k2ced5211gc2690e76f53a98be@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <48CD43C1.2090902@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
 <48C66829.1010902@grumpydevil.homelinux.org>
 <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
 <48CC42D8.8080806@gmail.com>
 <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
 <48CC4D35.3000003@gmail.com>
 <d9def9db0809140838k2ced5211gc2690e76f53a98be@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Markus Rechberger wrote:
>>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>> Markus Rechberger wrote:
>>>>
>>>>> How many devices are currently supported by the multiproto API
>>>>> compared with the s2 tree?
>>>> The initial set of DVB-S2 multistandard devices supported by the
>>>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>>>> alone. There are more additions by 2 more modules (not devices), but for
>>>> the simple comparison here is the quick list of them, for which some of
>>>> the manufacturers have shown support in some way. (There has been quite
>>>> some contributions from the community as well.):
>>>>
>>>> (Also to be noted is that, some BSD chaps also have shown interest in
>>>> the same)
>>>>
>>> they're heavy into moving the whole framework over as far as I've seen
>>> yes, also including yet unmerged drivers.
>>
>> Using the same interface, the same applications will work there as well
>> which is a bonus, but isn't the existing user interface GPL ? (A bit
>> confused on that aspect)
>>
>>
>>>> * STB0899 based
>>>>
>>>> Anubis
>>>> Typhoon DVB-S2 PCI
>>>>
>>>> Azurewave/Twinhan
>>>> VP-1041
>>>> VP-7050
>>>>
>>>> Digital Now
>>>> AD SP400
>>>> AD SB300
>>>>
>>>> KNC1
>>>> TV Station DVB-S2
>>>> TV Station DVB-S2 Plus
>>>>
>>>> Pinnacle
>>>> PCTV Sat HDTV Pro USB 452e
>>>>
>>>> Satelco
>>>> TV Station DVB-S2
>>>> Easywatch HDTV USB CI
>>>> Easywatch HDTV PCI
>>>>
>>>> Technisat
>>>> Skystar HD
>>>> Skystar HD2
>>>> Skystar USB2 HDCI
>>>>
>>>> Technotrend
>>>> TT S2 3200
>>>> TT S2 3600
>>>> TT S2 3650
>>>>
>>>> Terratec
>>>> Cinergy S2 PCI HD
>>>> Cinergy S2 PCI HDCI
>>>>
>>> those are pullable now against the current tree?
>>
>> These devices, depend upon the DVB API update without which it wouldn't
>> work as they depend heavily on the DVB API framework. Without the
>> updated framework, it doesn't make any sense to pull them: they won't
>> even compile. The last but not least reason is that, the stb0899 driver
>> is a DVB-S2 multistandard device which requires DVB-S2/DSS support
>> additionally.
>>
> 
> so the framework is available, and the drivers could be pushed in
> right afterwards, I wonder
> who is willing to port those drivers to the other API (including testing).

Me. I'll port the 3200 cards and their derivatives, including the 6100 
and the 0899. I've already said I'd do that.... but it's manu's code and 
he retains all rights. He gets to decide first.


> It's not going to happen any time soon I guess, if there's not an
> agreement with Manu's
> work. Dumping this code would show another step of ignorance and
> selfishness against the
> people who worked on it.


The demod/tuners drivers would be merged with S2API within a few days. I 
have a TT-3200 here. I'd have to re-write various things, and change the 
demod API a little. but I'm prepared to do that.

Judging by the positive response we're having to the S2API tree, I 
suspect a number of people will be willing to offer patches, test time 
and support.

- Steve



