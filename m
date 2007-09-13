Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXIMQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXIMQwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXIMQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:52:46 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:56242 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbXIMQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Qdc3gZ4ScEeff9tz24sI3w8VQUsnNxPrHxqzPpNAG6ubPQzd0++G8kZLq+nbtHdIbmqVj6oFgfgHssUXky7JJ17TgwRQce87KRltnsMTX6gv3+C1u1s8cUtmQR3gdwmypzZ/DprBCJozvlAPJlqEC2CYGsm2vItaT9u5dn5yXDI=
Message-ID: <46E96AD4.6050707@gmail.com>
Date: Thu, 13 Sep 2007 20:52:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       akpm@linux-foundation.org
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>	 <20070913131353.GB26972@linuxtv.org>	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>	 <46E95C54.4060502@gmail.com>	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>	 <46E963CC.8010707@gmail.com> <d9def9db0709130932o2ca847f0xd4eb9c24560eb3ff@mail.gmail.com>
In-Reply-To: <d9def9db0709130932o2ca847f0xd4eb9c24560eb3ff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On 9/13/07, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Markus Rechberger wrote:
>>> On 9/13/07, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>>> It's only a step in development, I do not intend to keep the kernel
>>>>> stub in the end, but I do intend to keep and use the userspace drivers
>>>>> with i2c-dev in the long run, this requires a v4l/dvb library at the
>> front
>>>>> of everything.
>>>> Well, this was what adq and myself did with libdvbapi and mti, (much
>>>> before UIO was announced at LK.) It is not tied to I2C either.
>>>>
>>> I2C is the main communication path for it, although there are callback
>>> mechanisms available which add the possibility for different configuration
>>> paths.
>> Sorry, i must say that what you said is wrong.
>>
>> The example implementation in libdvbapi/mti is I2C only with a STV0299
>> on the TTPCI, if that was what you meant.
>> But if you need examples for every possible interface, then probably you
>> are out of luck.
>>
> 
> I didn't comment the libdvbapi/mti driver.
> I'm quite confident that non I2C protocols can be handled by a callback
> function. In the end it's either a usb control command or pci mmio writes

There's also DTL in some cases. It's not USB msgs and or PCI MMIO alone.
The actual DTL spec is unfortunately not open.

Manu

