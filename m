Return-Path: <linux-kernel-owner+w=401wt.eu-S1423317AbXDYIxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423317AbXDYIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423318AbXDYIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:53:49 -0400
Received: from itaqui.hst.terra.com.br ([200.176.10.211]:50194 "EHLO
	itaqui.hst.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423317AbXDYIxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:53:48 -0400
X-Terra-Karma: -2%
X-Terra-Hash: 274146f07e8bc88a0fe3df349d96aa40
Message-ID: <462DF5B1.5050907@centralinf.com.br>
Date: Tue, 24 Apr 2007 09:18:57 -0300
From: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4627D7CF.3070002@centralinf.com.br>	 <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>	 <462A9926.2030303@centralinf.com.br> <1177367429.12242.7.camel@localhost>
In-Reply-To: <1177367429.12242.7.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

The dynticks doesn't affect HPET here at all. The machine freeze with or 
w/o dynticks.

Gonna try the patch and i tell you.

Guilherme M. Schroeder
Network Administrator
Central de Vendas Informatica LTDA
Tel.: (11) 3665-2000 Ramal: 2008
http://www.centralinf.com.br


john stultz wrote:
> On Sat, 2007-04-21 at 20:07 -0300, Guilherme M. Schroeder wrote:
>> john stultz wrote:
>>> On 4/19/07, guilherme <guilherme@centralinf.com.br> wrote:
>>>> Hi,
>>>>
>>>> If i enable "High Resolution Timer Support", my machine stops here at 
>>>> boot:
>>>>
>>>> Clocksource tsc unstable (delta = -297340790165 ns)
>>>> Time: hpet clocksource has been installed.
>>>>
>>>> If i disable HPET, it boots fine.
>>> Hmmm.. What happens if you boot w/ clocksource=acpi_pm ?
>>>
>>>
>> Boot ok with clocksource=acpi_pm and HPET enabled.
>> Any clue?
> 
> 
> I'm suspecting that your HPET counter is being stopped for some reason,
> although why I have no idea.
> 
> Just to get a clear picture, does this happen w/ "Tickless System
> (Dynamic ticks)" disabled in the menuconfig?
> 
> Thomas, might we be actually stopping the HPET counter instead of
> disabling the HPET interrupt w/ dynticks?
> 
> thanks
> -john
> 
> 
> 
> 
