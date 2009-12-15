Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbZLODCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbZLODCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbZLODCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:02:35 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36535 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbZLODCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:02:34 -0500
Message-ID: <4B26FC52.6060307@billgatliff.com>
Date: Mon, 14 Dec 2009 21:02:42 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Aras Vaichas <arasv@magellan-technology.com>
CC: Pavel Machek <pavel@ucw.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [POWER] battery calibration parameters from sysfs
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>	 <20091204104930.GA28625@sirena.org.uk>	 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>	 <20091207114825.GA26965@rakim.wolfsonmicro.main>	 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>	 <20091207165628.GA24981@rakim.wolfsonmicro.main>	 <20091213132413.GB1437@ucw.cz>	 <20091214121247.GB22388@rakim.wolfsonmicro.main>	 <20091214212257.GA9213@elf.ucw.cz> <ed62800912141543v2ab7ef63v4b6b2c33018b3296@mail.gmail.com>
In-Reply-To: <ed62800912141543v2ab7ef63v4b6b2c33018b3296@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:
> Unfortunately the simple coulomb counting chips have the disadvantage
> that the CPU has to be running to accumulate the pulses. Of course,
> the pulses could wake the CPU from a suspend mode, but I'd rather not
> do that just to add "one" to a counter ...
>   

Could you have the coulomb-counting chip connected to a tiny
microcontroller, or even a dedicated hardware counter?  Then the main
CPU wouldn't need to wake as often, it could just ask the
microcontroller over I2C, or read/reset the hardware counter.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

