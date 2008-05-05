Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbYEEOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbYEEOVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbYEEOVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:21:36 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:62783 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759475AbYEEOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:21:35 -0400
Message-ID: <481F1830.5090309@seznam.cz>
Date: Mon, 05 May 2008 16:22:40 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 24/56] microblaze_v2: time support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>	 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>	 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>	 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>	 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>	 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>	 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>	 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>	 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>	 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu> <1209953949.5798.66.camel@localhost>
In-Reply-To: <1209953949.5798.66.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

you wrote me you have smarter implementation that xilinx did. Can you find it
and send me it?

Thanks,
M


>> +static inline void udelay(unsigned long usec)
>> +{
>> +	unsigned long long tmp = usec;
>> +	unsigned long loops = (tmp * 4295 * HZ * loops_per_jiffy) >> 32;
>> +	__delay(loops);
>> +}
> 
> Let's hope like hell the CPU has HW multipler and shifter for this
> one! :)
> 
>> +++ b/include/asm-microblaze/timex.h
>> @@ -0,0 +1,20 @@
>> +
>> +#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
> 
> What's this?  Is it used anywhere?
> 
> 
> 
> 
> 
