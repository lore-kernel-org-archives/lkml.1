Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZJNM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZJNM54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbZJNM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:57:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:52973 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbZJNM5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:57:55 -0400
Date: Wed, 14 Oct 2009 08:57:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: lm-sensors@lm-sensors.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
 DP55KG motherboard? (chip ID: 0xb473)
In-Reply-To: <alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan> <alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Justin Piszcz wrote:

>
>
> On Tue, 13 Oct 2009, Justin Piszcz wrote:
>
>> Hello,
>> 
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
>> 
>> Justin.
>> 
>
> I tried w83627ehf, to no avail:
>
> # modprobe w83627ehf
> FATAL: Error inserting w83627ehf 
> (/lib/modules/2.6.31.3/kernel/drivers/hwmon/w83627ehf.ko): No such device
>
> Justin.

With debugging enabled:

[56208.376451] w83627ehf: unsupported chip ID: 0xb473

Is there anything else needed from me/info about the board or once this ID 
is added into the kernel/src/etc it will work properly?

Justin.
