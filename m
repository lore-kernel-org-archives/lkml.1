Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYLVKs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYLVKs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYLVKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:48:18 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:45487 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYLVKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:48:17 -0500
Date: Mon, 22 Dec 2008 11:50:45 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/7] PCF50633 support
Message-ID: <20081222105044.GC2633@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081218055618.31696.65002.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218055618.31696.65002.stgit@cff.thadambail>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

On Thu, Dec 18, 2008 at 11:26:18AM +0530, Balaji Rao wrote:
> Changes from V1:
> 	- Subdevice specific header files now included in its respective patch.
> 	- Introduces pcf50633_register_irq and pcf50633_free_irq for irq
> 	  management
> 	- Many changes in how subdevices are created and information is passed
> 	  to them. Thanks to Alessandro Zummo for suggestions.
> 
> The following series implements support for NXP PCF50633. It's basically
> an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
> and a RTC.
> 
> This chip is used in Openmoko Neo Freerunner mobile phone.
> 
> Driver for a similar chip PCF50606, used in Openmoko Neo 1973 device
> will follow soon.
> 
> The specs are open and are available at 
> http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf
> 
> Samuel, are you ok with merging this via linux-mfd tree ?
Yes, I'm fine with it. Two things though:
- Could you please resend the non-mfd parts (patch 4,5,6 and 7) to me ?
- I see from the lkml archives that patches 5 and 6 didnt get Acked yet. I'll
queue them, but I'd really like to get Anton and Dmitry approval before
sending them upstream.

Cheers,
Samuel.


> 
> ---
> Balaji Rao (7):
>       mfd: PCF50633 core driver
>       mfd: PCF50633 adc driver
>       mfd: PCF50633 gpio support
>       rtc: PCF50633 rtc driver
>       power_supply: PCF50633 battery charger driver
>       input: PCF50633 input driver
>       regulator: PCF50633 pmic driver
> 
>  drivers/input/misc/Kconfig             |    7 
>  drivers/input/misc/Makefile            |    1 
>  drivers/input/misc/pcf50633-input.c    |  132 ++++++
>  drivers/mfd/Kconfig                    |   23 +
>  drivers/mfd/Makefile                   |    6 
>  drivers/mfd/pcf50633-adc.c             |  277 +++++++++++++
>  drivers/mfd/pcf50633-core.c            |  707 ++++++++++++++++++++++++++++++++
>  drivers/mfd/pcf50633-gpio.c            |  118 +++++
>  drivers/power/Kconfig                  |    6 
>  drivers/power/Makefile                 |    2 
>  drivers/power/pcf50633-charger.c       |  358 ++++++++++++++++
>  drivers/regulator/Kconfig              |    7 
>  drivers/regulator/Makefile             |    1 
>  drivers/regulator/pcf50633-regulator.c |  330 +++++++++++++++
>  drivers/rtc/Kconfig                    |    6 
>  drivers/rtc/Makefile                   |    1 
>  drivers/rtc/rtc-pcf50633.c             |  336 +++++++++++++++
>  include/linux/mfd/pcf50633/adc.h       |   72 +++
>  include/linux/mfd/pcf50633/core.h      |  218 ++++++++++
>  include/linux/mfd/pcf50633/gpio.h      |   52 ++
>  include/linux/mfd/pcf50633/mbc.h       |  134 ++++++
>  include/linux/mfd/pcf50633/pmic.h      |   68 +++
>  22 files changed, 2861 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/input/misc/pcf50633-input.c
>  create mode 100644 drivers/mfd/pcf50633-adc.c
>  create mode 100644 drivers/mfd/pcf50633-core.c
>  create mode 100644 drivers/mfd/pcf50633-gpio.c
>  create mode 100644 drivers/power/pcf50633-charger.c
>  create mode 100644 drivers/regulator/pcf50633-regulator.c
>  create mode 100644 drivers/rtc/rtc-pcf50633.c
>  create mode 100644 include/linux/mfd/pcf50633/adc.h
>  create mode 100644 include/linux/mfd/pcf50633/core.h
>  create mode 100644 include/linux/mfd/pcf50633/gpio.h
>  create mode 100644 include/linux/mfd/pcf50633/mbc.h
>  create mode 100644 include/linux/mfd/pcf50633/pmic.h
> 
> 
> -- 
> Thanks,
> Balaji Rao
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
