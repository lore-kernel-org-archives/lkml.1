Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYEHOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYEHOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYEHOOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:14:10 -0400
Received: from www.tglx.de ([62.245.132.106]:44288 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYEHOOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:14:08 -0400
Date: Thu, 8 May 2008 16:13:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from
 2.6.24)
In-Reply-To: <295530.5900.qm@web32602.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0805081609080.3318@apollo.tec.linutronix.de>
References: <295530.5900.qm@web32602.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Martin Knoblauch wrote:
> on two different systems running 2.6.25.2:
> 
> ibm x3650(2xDualCore)
> -------------------------------------
> [root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc hpet acpi_pm jiffies
> [root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> 
> HP Proliant DL-380G4 (2xSingleCore)
> ------------------------------------------------------------
> [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc hpet acpi_pm jiffies
> [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> 
> and on the DL380G4 running 2.6.24:
> ---------------------------------------------------------
> [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> hpet acpi_pm jiffies tsc
> [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> hpet

So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) ?

Thanks,
	tglx
