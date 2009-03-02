Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZCBVXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZCBVXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZCBVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:23:40 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36705 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZCBVXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:23:39 -0500
Date: Mon, 2 Mar 2009 22:23:35 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Tony Lindgren <tony@atomide.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "=?UTF-8?B?77+977+977+91L/vv70=?=" <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when
 resuming
Message-ID: <20090302222335.5776897c@mjolnir.ossman.eu>
In-Reply-To: <20090302164413.GB11864@atomide.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
	<200902231023.49653.david-b@pacbell.net>
	<49A3EF96.3090603@nokia.com>
	<200902241410.19132.david-b@pacbell.net>
	<20090227220812.GM11594@atomide.com>
	<49ABD098.8080108@nokia.com>
	<20090302164413.GB11864@atomide.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 08:44:14 -0800
Tony Lindgren <tony@atomide.com> wrote:

> * Adrian Hunter <adrian.hunter@nokia.com> [090302 04:27]:
> > From a2ad80abeb9550782d4962472980e47df4055434 Mon Sep 17 00:00:00 2001
> > From: Kim Kyuwon <chammoru@gmail.com>
> > Date: Fri, 20 Feb 2009 13:10:08 +0100
> > Subject: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when resuming
> >
> > Most registers lose its state when the processor wakes up from sleep state.
> > Thus registers should be initialized, when the processor wakes up. However the
> > current hsmmc 'resume' function doesn't consider this issue and finally makes
> > deadlock. So this patch fixes this problem.
> >
> > Signed-off-by: Kim Kyuwon <chammoru@gmail.com>
> > Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> 
> Sounds like there's no rush to get this into mainline until during the
> next merge window as we're still missing most of the 24xx and 34xx PM code.
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> 

Queued up both patches for the next merge window.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
