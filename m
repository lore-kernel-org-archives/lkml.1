Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZA2AxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZA2AxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZA2Awt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:52:49 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:18742 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbZA2Awr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:52:47 -0500
X-Trace: 138198401/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAAeMgElQLLDG/2dsb2JhbACBbslQhUcG
X-IronPort-AV: E=Sophos;i="4.37,340,1231113600"; 
   d="scan'208";a="138198401"
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and
 clean up maple bus driver (2/3)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <200901281944.57894.vapier@gentoo.org>
References: <1233186456.6734.16.camel@localhost.localdomain>
	 <1233187069.6734.21.camel@localhost.localdomain>
	 <1233187750.6734.27.camel@localhost.localdomain>
	 <200901281944.57894.vapier@gentoo.org>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 00:49:30 +0000
Message-Id: <1233190170.6734.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 19:44 -0500, Mike Frysinger wrote:
> On Wednesday 28 January 2009 19:09:10 Adrian McMenamin wrote:
> > +static struct maple_driver vmu_flash_driver = {
> > +	.function =	MAPLE_FUNC_MEMCARD,
> > +	.drv = {
> > +		.name =		"Dreamcast_visual_memory",
> 
> i thought there was like a 16byte limit or something on this ?


Don't think so, it's just a const char* isn't it?

