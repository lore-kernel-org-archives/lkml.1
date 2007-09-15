Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbXIOPvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbXIOPvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXIOPvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:51:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43457 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXIOPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:51:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EBFF5C.8090605@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 17:50:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Andi Kleen <andi@firstfloor.org>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: x86_64 usability bug: Kconfig prompt without help text (was Re: sata
 & scsi suggestion for make menuconfig)
References: <20070907124800.GP16806@vanheusden.com>	<p73fy1p9m57.fsf@bingen.suse.de>	<1189371621.3526.28.camel@localhost.localdomain>	<20070909210329.GE25798@one.firstfloor.org>	<46E46190.6080607@garzik.org>	<20070912224655.GC3563@stusta.de>	<46EAA08F.30703@s5r6.in-berlin.de>	<20070914151522.GL3563@stusta.de>	<20070915080448.37457dcf@tux.DEF.witbe.net>	<46EB9703.70705@s5r6.in-berlin.de> <20070915130010.4272403c@tux.DEF.witbe.net>
In-Reply-To: <20070915130010.4272403c@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I take the liberty to modify the CC list.

Paul Rolland wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I assert that a Kconfig prompt (a visible Kconfig variable) _without_
>> help text is a bug.
> 
> Here is an example from 2.6.34-rc6 :
>  .config - Linux Kernel v2.6.23-rc6 Configuration
> ------------------------------------------------------------------------------
>  +------------------------- Provide RTC interrupt -------------------------+ 
>  | There is no help available for this kernel option.                      |
>  | Symbol: HPET_EMULATE_RTC [=y]                                           |
>  | Prompt: Provide RTC interrupt                                           |
>  |   Defined at arch/x86_64/Kconfig:471                                    |
>  |   Depends on: HPET_TIMER && RTC=y                                       |
>  |   Location:                                                             |
>  |   -> Processor type and features |   

The same prompt existed in arch/i386/Kconfig without help text too but
it was later made invisible and automatic by pre-2.6.13 patch "remove
special HPET_EMULATE_RTC config option", commit
c91096d85c95c6b7fe8d7065e2aa6825e0bdaca9: "We had a user whose apps
weren't working correctly because his "rtc" wasn't working fully.  For
the sake of simplicity, it seems sensible to always enable HPET RTC
emulation."

  - So, which criteria influence whether HPET_EMULATE_RTC should be
    enabled on x86_64 or not?

  - In case that there is no compelling reason to disable it if its
    dependencies are satisfied, shouldn't it rather be invisible and
    automatic like on i386?
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
