Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYHGAOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYHGAOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYHGAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:14:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52111 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYHGAOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:14:36 -0400
Date: Wed, 6 Aug 2008 17:13:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: dwmw2@infradead.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 5 (MTD build error)
Message-Id: <20080806171348.a129245b.randy.dunlap@oracle.com>
In-Reply-To: <200808060413.08723.david-b@pacbell.net>
References: <20080805175914.7649537f.sfr@canb.auug.org.au>
	<20080805175518.9fc09b92.randy.dunlap@oracle.com>
	<200808060320.20064.david-b@pacbell.net>
	<200808060413.08723.david-b@pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 04:13:08 -0700 David Brownell wrote:

> On Wednesday 06 August 2008, David Brownell wrote:
> > On Tuesday 05 August 2008, Randy Dunlap wrote:
> > > 
> > > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c: In function 'add_dataflash_otp':
> > > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c:670: error: too many arguments to function 'otp_setup'
> > 
> > Bad merge somewhere? 
> 
> Whoops, sorry ... I see what was going on.  My bad.
> 
> --- g26.orig/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:12:45.000000000 -0700
> +++ g26/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:11:55.000000000 -0700
> @@ -616,7 +616,7 @@ static char *otp_setup(struct mtd_info *
>  
>  #else
>  
> -static char *otp_setup(struct mtd_info *device)
> +static char *otp_setup(struct mtd_info *device, char revision)
>  {
>  	return " (OTP)";
>  }
> --

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, David.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
