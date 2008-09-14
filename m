Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYINCLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYINCLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 22:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYINCK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 22:10:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:43508 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYINCKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 22:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bJA+r04N81AKwMGUSrLzSsQFdaliSFMscJbpal9FDVEcyyN3/4K8Wlk0hAsB4mU0WF
         kaYt9m+OmBMMNQpLFToPFVbZYF0elruKvh9HOBx7QnpfAz6mBlXngeeOiwpBbRvGf8lY
         IrkRItxFma8fzdMYAEjh3BXzMQWHUTzjnDaVA=
Message-ID: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
Date: Sun, 14 Sep 2008 04:10:53 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Cc: linux-dvb@linuxtv.org, "Rudy Zijlstra" <rudy@grumpydevil.homelinux.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48CC4D35.3000003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	 <48C66829.1010902@grumpydevil.homelinux.org>
	 <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	 <48CC42D8.8080806@gmail.com>
	 <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
	 <48CC4D35.3000003@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Markus Rechberger wrote:
>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> Markus Rechberger wrote:
>>>
>>>> How many devices are currently supported by the multiproto API
>>>> compared with the s2 tree?
>>> The initial set of DVB-S2 multistandard devices supported by the
>>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>>> alone. There are more additions by 2 more modules (not devices), but for
>>> the simple comparison here is the quick list of them, for which some of
>>> the manufacturers have shown support in some way. (There has been quite
>>> some contributions from the community as well.):
>>>
>>> (Also to be noted is that, some BSD chaps also have shown interest in
>>> the same)
>>>
>>
>> they're heavy into moving the whole framework over as far as I've seen
>> yes, also including yet unmerged drivers.
>
>
> Using the same interface, the same applications will work there as well
> which is a bonus, but isn't the existing user interface GPL ? (A bit
> confused on that aspect)
>

I think it's good to have something that competes with Linux, I talked to some
guys at that front too, and they seem to work close with application
developers too
As for the em28xx driver I agreed with pushing all my code (in case of
linux, which
includes unmerged independent drivercode from manufacturers) into their system
using their license.

>
>>> * STB0899 based
>>>
>>> Anubis
>>> Typhoon DVB-S2 PCI
>>>
>>> Azurewave/Twinhan
>>> VP-1041
>>> VP-7050
>>>
>>> Digital Now
>>> AD SP400
>>> AD SB300
>>>
>>> KNC1
>>> TV Station DVB-S2
>>> TV Station DVB-S2 Plus
>>>
>>> Pinnacle
>>> PCTV Sat HDTV Pro USB 452e
>>>
>>> Satelco
>>> TV Station DVB-S2
>>> Easywatch HDTV USB CI
>>> Easywatch HDTV PCI
>>>
>>> Technisat
>>> Skystar HD
>>> Skystar HD2
>>> Skystar USB2 HDCI
>>>
>>> Technotrend
>>> TT S2 3200
>>> TT S2 3600
>>> TT S2 3650
>>>
>>> Terratec
>>> Cinergy S2 PCI HD
>>> Cinergy S2 PCI HDCI
>>>
>>
>> those are pullable now against the current tree?
>
>
> These devices, depend upon the DVB API update without which it wouldn't
> work as they depend heavily on the DVB API framework. Without the
> updated framework, it doesn't make any sense to pull them: they won't
> even compile. The last but not least reason is that, the stb0899 driver
> is a DVB-S2 multistandard device which requires DVB-S2/DSS support
> additionally.
>

as far as I understood here it's that alot code is already available
and has been tested for
a couple of years, a few guys are trying to run their own game since
they already have
 "some" code, and the problem is that people would have to port your
drivers to the
other system without your support. We've seen the same issue with the
em28xx a year ago,
although this one is participating at the BSD and OSX project now too
(which takes the same
source and makes alot more sence in terms of contributions).
As soon as the em28xx code supports the mt2060 and saa7114 devices it
would be ready
to go into the kernel again separated from linuxtv...

Markus
