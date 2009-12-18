Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbZLRItT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbZLRItT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZLRItH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:49:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60423 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZLRItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:49:02 -0500
Date: Fri, 18 Dec 2009 09:48:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andy Green <andy@warmcat.com>
Cc: Stanislav Brabec <utx@penguin.cz>,
       Aras Vaichas <arasv@magellan-technology.com>,
       Bill Gatliff <bgat@billgatliff.com>, thommycheck@gmail.com,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-embedded@vger.kernel.org, lenz@cs.wisc.edu, dbaryshkov@gmail.com,
       Brian Swetland <swetland@google.com>, arminlitzel@web.de,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de, cbou@mail.ru,
       rpurdie@rpsys.net, omegamoon@gmail.com, Cyril Hrubis <metan@ucw.cz>,
       eric.y.miao@gmail.com, dwmw2@infradead.org,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091218084850.GA1513@ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se> <20091207165628.GA24981@rakim.wolfsonmicro.main> <20091213132413.GB1437@ucw.cz> <20091214121247.GB22388@rakim.wolfsonmicro.main> <20091214212257.GA9213@elf.ucw.cz> <ed62800912141543v2ab7ef63v4b6b2c33018b3296@mail.gmail.com> <4B26FC52.6060307@billgatliff.com> <ed62800912151458p6bc1e551g54960af40c54facd@mail.gmail.com> <1260919938.10441.18.camel@utx.utx.cz> <4B28AAFC.5010108@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B28AAFC.5010108@warmcat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!1


>>> Yes, but in that case you might as well just purchase a coulomb
>>> counter with a built-in accumulator and an I2C/SPI/microwire interface
>>> save yourself some PCB space and cost (maybe)

Hardware is already given.

>> Well, Pavel attempts to implement a "poor man's Coulomb counter" or at
>> least "poor man's Ampere meter" for devices that are not equipped with
>> any of it.
>
> I think the "poor man's Coulomb counter" is a loser, the errors will  
> overwhelm you too rapidly.  The estimated rate of discharge could
>> work,  

Actually android phones do "poor man's Coulomb counter", and it seems
to mostly work.

> based on what clocks, regulators and so on are running, but I am not  
> sure how useful that number is really given you can't realistically  
> integrate it due to the big error it is bound to have.
...
> Otherwise for L-ion batteries, looking at the voltage level alone,  
> filtered to remove GSM transmit slots etc, is really quite workable for  
> estimating charge status.

Well, you have to compensate for backlight power; and yes, that's what
I'm trying to do.
								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
