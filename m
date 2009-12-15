Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZLOXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZLOXbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbZLOXbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:31:34 -0500
Received: from ns.penguin.cz ([84.21.108.25]:37694 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbZLOXbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:31:31 -0500
Subject: Re: [POWER] battery calibration parameters from sysfs
From: Stanislav Brabec <utx@penguin.cz>
To: Aras Vaichas <arasv@magellan-technology.com>
Cc: Bill Gatliff <bgat@billgatliff.com>, Pavel Machek <pavel@ucw.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       zaurus-devel@www.linuxtogo.org
In-Reply-To: <ed62800912151458p6bc1e551g54960af40c54facd@mail.gmail.com>
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
	 <ed62800912151458p6bc1e551g54960af40c54facd@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Wed, 16 Dec 2009 00:32:18 +0100
Message-Id: <1260919938.10441.18.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:

> Yes, but in that case you might as well just purchase a coulomb
> counter with a built-in accumulator and an I2C/SPI/microwire interface
> save yourself some PCB space and cost (maybe)

Well, Pavel attempts to implement a "poor man's Coulomb counter" or at
least "poor man's Ampere meter" for devices that are not equipped with
any of it.

- We know the time.
- We know the backlight power consumption, it's dependent only on
  brightness.
- We know how much eats the HDD and how long it is on.
- We know how much eats the CPU and companion chips (it is not as
  stable, but it eats less).
- We don't know, how much USB host eats, but we know how much USB
  clients claim to eat.
- Well, and we don't know how much eats CF and SD.

=> We can guess how many Coulombs the device already consumed. If the
Coulomb counting would be inaccurate, we can at least correct voltage ->
remaining energy table using current power consumption guess.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

