Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab0BYS4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:56:44 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59820 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab0BYS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:56:42 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19LIfwUB6/rWMd1DwfMCdNP
Date: Thu, 25 Feb 2010 10:57:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Thomas Weber <swirl@gmx.li>, "Aguirre, Sergio" <saaguirre@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Pandita, Vikram" <vikram.pandita@ti.com>,
       "Syed, Rafiuddin" <rafiuddin.syed@ti.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Weber <weber@corscience.de>
Subject: Re: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in
 early_init
Message-ID: <20100225185734.GI28173@atomide.com>
References: <1267090819-17796-1-git-send-email-swirl@gmx.li>
 <20100225184355.GF28173@atomide.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C43BF5EC@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C43BF5EC@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shilimkar, Santosh <santosh.shilimkar@ti.com> [100225 10:51]:
> 
> > -----Original Message-----
> > From: Tony Lindgren [mailto:tony@atomide.com]
> > Sent: Friday, February 26, 2010 12:14 AM
> > To: Thomas Weber; Aguirre, Sergio
> > Cc: linux-omap@vger.kernel.org; Russell King; Kevin Hilman; Shilimkar, Santosh; Pandita, Vikram;
> > Syed, Rafiuddin; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Thomas Weber
> > Subject: Re: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in early_init
> > 
> > * Thomas Weber <swirl@gmx.li> [100225 01:36]:
> > >
> > > The omap_serial_early_init prints the following errors:
> > >
> > > Could not get uart4_ick
> > > Could not get uart4_fck
> > >
> > > because all the uarts available in omap_uart[] will be initialized.
> > > Only omap4430 and omap3630 have 4 uarts at the moment.
> > > This patch reduces the number of uarts when cpu is not omap4430 or
> > > omap3630.
> > 
> > ..and I only patched omap_serial_init and forgot about
> > the omap_serial_early_init..
> > 
> > Looks good to me, Sergio, care to test and Ack this? Also, sounds
> > like we still need to patch omap4 for uart4 for the clocks.
> > 
> Clocks will be take care automatically by "nr_ports" for omap4 too
> with this patch. Below clock changes are just cosmetic ones, isn't it ?
> 
> Am I missing something?

Yes sorry, I'm referring to "[RFC][PATCH 0/3] OMAP3630: UART4 startup"
series to fix the uart4 issues for 3630, not omap4.

Regards,

Tony
