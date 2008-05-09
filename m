Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYEILcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYEILcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYEILc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:32:27 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:46739 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752931AbYEILc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:32:27 -0400
X-YMail-OSG: y0XWH24VM1mBeNN0Y_2o8t3lPanDyAjoCIx.3l1G23xDrrJDlPRAHEdMNgH7G_f4jzna6Yy7581Sr8AXVi3lWfQbMW4fV5TV6oe8j2S7sSrC1a4Y0Nweyo2uZ3zWmC.DLVJV8ieRpbUnTio-
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 9 May 2008 04:32:26 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br,
       John Stultz <johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <156547.88374.qm@web32605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 ------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de


----- Original Message ----
> From: Thomas Gleixner <tglx@linutronix.de>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Gabriel C <nix.or.die@googlemail.com>; Bart Van Assche <bart.vanassche@gmail.com>; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Thursday, May 8, 2008 4:13:55 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> On Thu, 8 May 2008, Martin Knoblauch wrote:
> > on two different systems running 2.6.25.2:
> > 
> > ibm x3650(2xDualCore)
> > -------------------------------------
> > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > HP Proliant DL-380G4 (2xSingleCore)
> > ------------------------------------------------------------
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > and on the DL380G4 running 2.6.24:
> > ---------------------------------------------------------
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > hpet acpi_pm jiffies tsc
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > hpet
> 
> So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
> thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) ?
> 
> Thanks,
>     tglx

 Just for documentation, I have opened:

http://bugzilla.kernel.org/show_bug.cgi?id=10656

Cheers
Martin

