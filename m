Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbZJOIbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbZJOIbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZJOIbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:31:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:58735 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbZJOIbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:31:08 -0400
Date: Thu, 15 Oct 2009 04:30:29 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jean Delvare <khali@linux-fr.org>
cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
  DP55KG motherboard? (chip ID: 0xb473)
In-Reply-To: <20091015100557.22243433@hyperion.delvare>
Message-ID: <alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan> <alpine.DEB.2.00.0910140403150.15961@p34.internal.lan> <alpine.DEB.2.00.0910140856190.19307@p34.internal.lan> <20091015100557.22243433@hyperion.delvare>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Jean Delvare wrote:

> Hi Justin,
>
> On 13/14 Oct 2009, Justin Piszcz wrote:
>> # uname -a
>> Linux box 2.6.31.3 #2 SMP Wed Oct 14 04:55:36 EDT 2009 x86_64 GNU/Linux
>>
>> I have a DP55KG motherboard, it says Ibex support was added here:
>> http://www.lm-sensors.org/changeset/5375
>>
>> # sensors
>> No sensors found!
>> Make sure you loaded all the kernel drivers you need.
>> Try sensors-detect to find out which these are.
>>
>> I have all of the modules compiled into the kernel and sensors-detect does
>> not find anything.
>>
>> 00:1f.3 SMBus: Intel Corporation Ibex Peak SMBus Controller (rev 05)
>>
>> Any ideas?
>
> The "Ibex support" in question only refers to the SMBus controller, not
> to sensors directly.
>
>> I tried w83627ehf, to no avail:
>>
>> # modprobe w83627ehf
>> FATAL: Error inserting w83627ehf
>> (/lib/modules/2.6.31.3/kernel/drivers/hwmon/w83627ehf.ko): No such device
>>
>> (...)
>> With debugging enabled:
>>
>> [56208.376451] w83627ehf: unsupported chip ID: 0xb473
>>
>> Is there anything else needed from me/info about the board or once this ID
>> is added into the kernel/src/etc it will work properly?
>
> We have never heard of this chip ID. This must be a brand new
> Winbond/Nuvoton Super-I/O chip. Please look at the motherboard, search
> for the Super-I/O and report the top marking. You may also find its
> name in the user manual (but the top marking is even more reliable.)
>
> -- 
> Jean Delvare
>

Hello,

A picture of it is available here:
http://img.hexus.net/v2/cpu/intel/LGA1156/IMG_0831-big.jpg
Another:
http://www.overclockersclub.com/vimages/intel_corei5750_corei7870/20.jpg
Another:
http://www.hitechlegion.com/images/stories/ici7_870/11.jpg
A close up of the chip itself!
http://www.motherboards.org/imageview.html?i=/images/reviews/motherboards/1948_p3_13.jpg

Is this the chip to which you are referring?

Winbond
W83677HG-i
919S9BE918B001FB
919S9BE918B001FB*typed twice to confirm (same #s on two different 
board/reviews)

Is there anything else needed?

This site shows a close up of nearly every part of the board:
http://www.motherboards.org/reviews/motherboards/1948_3.html

Thanks,

Justin.

