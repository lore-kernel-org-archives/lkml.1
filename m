Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZHSQw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZHSQw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZHSQw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:52:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:2364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZHSQwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QriyGXJEAiJelC47yVlxbfpHn5UlY164OG0YQI8hBx7pkPHDTSKpb3ZOXN9wVkO+HL
         0E+eUa+Nj7WUOUT/cv3S5EAVB8Cbn1dMEvBYeLIsLfERjoU6GS6LCzOcw1XTZSYIg7p+
         bgHPz8m1nRU8+pjLyeQgL+y24EYRj3eFCCWbE=
MIME-Version: 1.0
In-Reply-To: <20090819143223.GU5065@prithivi.gnumonks.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org>
	 <20090619231132.22296525@hyperion.delvare>
	 <191fb4ca0906271134r2c9761e3la56bdea3f66b60f4@mail.gmail.com>
	 <191fb4ca0908131142m4f976d98yb434da72257f64ea@mail.gmail.com>
	 <20090819143223.GU5065@prithivi.gnumonks.org>
Date: Wed, 19 Aug 2009 09:52:25 -0700
Message-ID: <191fb4ca0908190952l773fca65y5b38c88a1bf029d2@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core 
	temperature
From: Juerg Haefliger <juergh@gmail.com>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,


> On Thu, Aug 13, 2009 at 11:42:17AM -0700, Juerg Haefliger wrote:
>> Jean,
>>
>> Harald seems to be to busy to answer emails. Can we push my driver upstream?
>
> Well, I am not too busy anymore.  A terrible number of weeks just behind me.

Good to hear :-)


> Sorry for the delays.
>
> I personally don't really care which driver is merged, just as long as one of
> them ends up in mainline.


Do you have any answers to my previous questions:

1) My driver uses the CPUID instruction to read the performance
registers that contain the temp and voltage data. Harald's driver
reads MSRs. I don't know if there are any benefits of using one method
over the other.

2) If we pick Harald's, it would be nice if his driver can also read
and export the CPU core voltage.

3) Quite a few testers of my driver reported 0 temp readings for some
C7 CPUs. I was never able to figure out why some CPUs return 0 temp
but I'm guessing it depends on the thermal monitor settings. I'd like
to understand what is going on and hope Harald can shed some light.


...juerg


> - Harald Welte <HaraldWelte@viatech.com>            http://linux.via.com.tw/
> ============================================================================
> VIA Free and Open Source Software Liaison
>
