Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbXDWWbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbXDWWbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXDWWbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:31:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35934 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbXDWWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:30:34 -0400
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
From: john stultz <johnstul@us.ibm.com>
To: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <462A9926.2030303@centralinf.com.br>
References: <4627D7CF.3070002@centralinf.com.br>
	 <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>
	 <462A9926.2030303@centralinf.com.br>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 15:30:28 -0700
Message-Id: <1177367429.12242.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 20:07 -0300, Guilherme M. Schroeder wrote:
> john stultz wrote:
> > On 4/19/07, guilherme <guilherme@centralinf.com.br> wrote:
> >> Hi,
> >>
> >> If i enable "High Resolution Timer Support", my machine stops here at 
> >> boot:
> >>
> >> Clocksource tsc unstable (delta = -297340790165 ns)
> >> Time: hpet clocksource has been installed.
> >>
> >> If i disable HPET, it boots fine.
> > 
> > Hmmm.. What happens if you boot w/ clocksource=acpi_pm ?
> > 
> > 
>
> Boot ok with clocksource=acpi_pm and HPET enabled.
> Any clue?


I'm suspecting that your HPET counter is being stopped for some reason,
although why I have no idea.

Just to get a clear picture, does this happen w/ "Tickless System
(Dynamic ticks)" disabled in the menuconfig?

Thomas, might we be actually stopping the HPET counter instead of
disabling the HPET interrupt w/ dynticks?

thanks
-john


