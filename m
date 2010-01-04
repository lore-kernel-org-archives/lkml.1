Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394Ab0ADNyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0ADNyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193Ab0ADNyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:54:08 -0500
Received: from lucidpixels.com ([75.144.35.66]:40865 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0ADNyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:54:06 -0500
Date: Mon, 4 Jan 2010 08:54:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
 temp/voltage monitoring)
In-Reply-To: <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>  <4964DB3E.6080908@intel.com>  <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>  <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>  <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
 <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1823694196-1262613243=:29475"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1823694196-1262613243=:29475
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 4 Jan 2010, Gabriel C wrote:

> 2009/2/12 Justin Piszcz <jpiszcz@lucidpixels.com>:
>>
>>
>> On Thu, 12 Feb 2009, Gabriel C wrote:
>>
>>> Maxim Levitsky wrote:
>>>
>>>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>>>>
>>>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>>>
>>>>>> Justin Piszcz wrote:
>>>>>>>
>>>>>>> The HECI interface would allow lm_sensors developers to grab the
>>>>>>> temperatures off the chips on the board.
>>>>>>>
>>>>>>> From 2005(?)-2008 there was some chatter about supporting it but it
>>>>>>> never
>>>>>>> seemed to happen, is there any eventual planned support for support=
ing
>>>>>>> Intel's HECI interface or if the user wants to see the
>>>>>>> temperatures/voltages just buy a different motherboard with an ITE =
I/O
>>>>>>> controller?
>>>>>>>
>>>>>>> I have a couple DG965WH boards and it would be nice to see the
>>>>>>> temperature of the chipset etc without having to reboot into the BI=
OS.
>>>>>>>
>>>>>> Hi Justin,
>>>>>>
>>>>>> I am not up to date on the progress in this area, but perhaps this s=
ite
>>>>>> (http://www.openamt.org/) has what you are looking for?
>>>>>>
>>>>>> Regards,
>>>>>> Dan
>>>>>>
>>>>> Yeah that is the site-- however, will it ever get merged? =A0I have n=
ot
>>>>> heard anything about it for a year or so.
>>>>
>>>> Nope, the heci is just a controller, but we need a way to tell that
>>>> controller to show us the temperature data.
>>>> But intel hasn't released the QST sdk, and probably never will.
>>>>
>>>> Sad,
>>>
>>>
>>> Well I found this interesting thread about :
>>>
>>>
>>> http://software.intel.com/en-us/forums/manageability-software-developme=
nt/topic/54851/
>>>
>>> It looks like the QST SDK already exists and is planned to be released.=
=2E
>>> (
>>> =A0http://software.intel.com/en-us/forums/manageability-software-develo=
pment/topic/54851/reply/74068/
>>> )
>> I volunteer to test any patches if/when they are created after the SDK i=
s
>> released.
>>
>
>
> Again me .. Well the SDK is *still* not released .. =A0The Intel folks
> said back in August :
>
> "The latest word is that the SDK is being prepared for approval but it
> is contingent upon an upcoming platform release."
>
> ( whatever that means )
>
>
> Anyway Andriy Gapon has posted on lm-sensors some nice tool to read
> the sensors output ( thx :) )
> (http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026830.htm=
l)
>
> Today I'm out from hospital so I've decided to quick hack this tool
> and make it work on Linux.
>
> Here the output from my DQ45CB mobo:
>
> crazy@thor:~/INTEL/QST/Li$ sudo ./heci-qst
> CPU =A0Temp: =A0 =A0 =A056.00 =A0 =B0C
> MB =A0 Temp: =A0 =A0 =A031.14 =A0 =B0C
> ICH =A0Temp: =A0 =A0 =A067.37 =A0 =B0C
> MCH =A0Temp: =A0 =A0 =A066.00 =A0 =B0C
> CPU =A0Fan: =A0 =A0 =A0 1080 =A0 =A0RPM
> INL =A0Fan: =A0 =A0 =A0 1202 =A0 =A0RPM
> OUTL Fan: =A0 =A0 =A0 288 =A0 =A0 RPM
> +12 =A0Volts: =A0 =A0 11.965 =A0V
> +5 =A0 Volts: =A0 =A0 5.021 =A0 V
> +3.3 Volts: =A0 =A0 3.316 =A0 V
> MCH =A0Vccp: =A0 =A0 =A01.122 =A0 V
> CPU1 Vccp: =A0 =A0 =A01.125 =A0 V
>
> Justin I know is not based on released SDK of Intel but maybe you
> still want to do some tests ?:)
Hi,

I upgraded my system and have a new board now, I do have another system tha=
t
uses the same board (DG965WH) if you have a patch/URL with the software I
can give it a run.

Justin.

>
> ( of course you need the heci kernel modules first )
>
> @Andriy there is a smallish bug in your original code .. you should
> use ..... , abs(value) ...., abs(value) ...);
> that will solve the negative CPU TEMP values you get with your version.
>
> Best Regards,
>
> Gabriel C
>
---1463747160-1823694196-1262613243=:29475--
