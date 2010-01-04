Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386Ab0ADOJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0ADOJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524Ab0ADOJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:09:22 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:49688 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0ADOJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KmvTcr4uwEj3rMKsD+sJGwBgVAzWsSgEhsxoSOf9CknAZQUkWWPA2LWJi6tMoM6Q4g
         jhaSIr7WSA4cB9E7RIq7wVKS23/FNFlML297haEeUJtL2jOJQgGEj5d3YPLi/BDCR5W5
         SXL07IvZV/Cu7lDVeLlsiMYlSxoogDkP9tNrY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
	 <4964DB3E.6080908@intel.com>
	 <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
	 <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
	 <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
	 <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
	 <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>
Date: Mon, 4 Jan 2010 15:09:17 +0100
Message-ID: <1820d69d1001040609j6c0b169w38694c33af3fa686@mail.gmail.com>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
	temp/voltage monitoring)
From: Gabriel C <nix.or.die@googlemail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/4 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
>
> On Mon, 4 Jan 2010, Gabriel C wrote:
>
>> 2009/2/12 Justin Piszcz <jpiszcz@lucidpixels.com>:
>>>
>>>
>>> On Thu, 12 Feb 2009, Gabriel C wrote:
>>>
>>>> Maxim Levitsky wrote:
>>>>
>>>>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>>>>>
>>>>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>>>>
>>>>>>> Justin Piszcz wrote:
>>>>>>>>
>>>>>>>> The HECI interface would allow lm_sensors developers to grab the
>>>>>>>> temperatures off the chips on the board.
>>>>>>>>
>>>>>>>> From 2005(?)-2008 there was some chatter about supporting it but it
>>>>>>>> never
>>>>>>>> seemed to happen, is there any eventual planned support for
>>>>>>>> supporting
>>>>>>>> Intel's HECI interface or if the user wants to see the
>>>>>>>> temperatures/voltages just buy a different motherboard with an ITE
>>>>>>>> I/O
>>>>>>>> controller?
>>>>>>>>
>>>>>>>> I have a couple DG965WH boards and it would be nice to see the
>>>>>>>> temperature of the chipset etc without having to reboot into the
>>>>>>>> BIOS.
>>>>>>>>
>>>>>>> Hi Justin,
>>>>>>>
>>>>>>> I am not up to date on the progress in this area, but perhaps this
>>>>>>> site
>>>>>>> (http://www.openamt.org/) has what you are looking for?
>>>>>>>
>>>>>>> Regards,
>>>>>>> Dan
>>>>>>>
>>>>>> Yeah that is the site-- however, will it ever get merged?  I have not
>>>>>> heard anything about it for a year or so.
>>>>>
>>>>> Nope, the heci is just a controller, but we need a way to tell that
>>>>> controller to show us the temperature data.
>>>>> But intel hasn't released the QST sdk, and probably never will.
>>>>>
>>>>> Sad,
>>>>
>>>>
>>>> Well I found this interesting thread about :
>>>>
>>>>
>>>>
>>>> http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/
>>>>
>>>> It looks like the QST SDK already exists and is planned to be released..
>>>> (
>>>>
>>>>  http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/reply/74068/
>>>> )
>>>
>>> I volunteer to test any patches if/when they are created after the SDK is
>>> released.
>>>
>>
>>
>> Again me .. Well the SDK is *still* not released ..  The Intel folks
>> said back in August :
>>
>> "The latest word is that the SDK is being prepared for approval but it
>> is contingent upon an upcoming platform release."
>>
>> ( whatever that means )
>>
>>
>> Anyway Andriy Gapon has posted on lm-sensors some nice tool to read
>> the sensors output ( thx :) )
>>
>> (http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026830.html)
>>
>> Today I'm out from hospital so I've decided to quick hack this tool
>> and make it work on Linux.
>>
>> Here the output from my DQ45CB mobo:
>>
>> crazy@thor:~/INTEL/QST/Li$ sudo ./heci-qst
>> CPU  Temp:      56.00   °C
>> MB   Temp:      31.14   °C
>> ICH  Temp:      67.37   °C
>> MCH  Temp:      66.00   °C
>> CPU  Fan:       1080    RPM
>> INL  Fan:       1202    RPM
>> OUTL Fan:       288     RPM
>> +12  Volts:     11.965  V
>> +5   Volts:     5.021   V
>> +3.3 Volts:     3.316   V
>> MCH  Vccp:      1.122   V
>> CPU1 Vccp:      1.125   V
>>
>> Justin I know is not based on released SDK of Intel but maybe you
>> still want to do some tests ?:)
>
> Hi,
>
> I upgraded my system and have a new board now, I do have another system that
> uses the same board (DG965WH) if you have a patch/URL with the software I
> can give it a run.

The file was attached ..

Just do:

gcc -o heci-qst heci-qst-linux.c

>
> Justin.

Gabriel
