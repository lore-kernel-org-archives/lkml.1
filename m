Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZLOXZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZLOXZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbZLOXY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:24:56 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41909 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752058AbZLOW6R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <4B26FC52.6060307@billgatliff.com>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
	 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
	 <20091207114825.GA26965@rakim.wolfsonmicro.main>
	 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
	 <20091207165628.GA24981@rakim.wolfsonmicro.main>
	 <20091213132413.GB1437@ucw.cz>
	 <20091214121247.GB22388@rakim.wolfsonmicro.main>
	 <20091214212257.GA9213@elf.ucw.cz>
	 <ed62800912141543v2ab7ef63v4b6b2c33018b3296@mail.gmail.com>
	 <4B26FC52.6060307@billgatliff.com>
Date: Wed, 16 Dec 2009 09:58:16 +1100
Message-ID: <ed62800912151458p6bc1e551g54960af40c54facd@mail.gmail.com>
Subject: Re: [POWER] battery calibration parameters from sysfs
From: Aras Vaichas <arasv@magellan-technology.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/15 Bill Gatliff <bgat@billgatliff.com>:
> Aras Vaichas wrote:
>> Unfortunately the simple coulomb counting chips have the disadvantage
>> that the CPU has to be running to accumulate the pulses. Of course,
>> the pulses could wake the CPU from a suspend mode, but I'd rather not
>> do that just to add "one" to a counter ...
>>
>
> Could you have the coulomb-counting chip connected to a tiny
> microcontroller, or even a dedicated hardware counter?  Then the main
> CPU wouldn't need to wake as often, it could just ask the
> microcontroller over I2C, or read/reset the hardware counter.
>
> b.g.

Yes, but in that case you might as well just purchase a coulomb
counter with a built-in accumulator and an I2C/SPI/microwire interface
save yourself some PCB space and cost (maybe)

Google for, say,  "coulomb counter i2c" and you'll get something like
this: http://eu.st.com/stonline/products/literature/ds/15269.pdf as an
example

The only time we used a pulse-and-polarity-output coulomb counter was
with an ATmega128. The CPU had to run all the time in order to
maintain its RTC so we could use it to accumulate pulses as well. It
wasn't a Linux project though.

Aras
