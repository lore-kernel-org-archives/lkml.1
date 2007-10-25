Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXJYWHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXJYWHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJYWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:07:09 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:46537 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXJYWHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:07:08 -0400
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 18:07:08 EDT
Subject: Re: [PATCH] ata: ahci: Enable enclosure management via LED (resend)
From: Richard Purdie <rpurdie@openedhand.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       akpm@linux-foundation.org, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710252335.12975.ioe-lkml@rameria.de>
References: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
	 <200710252335.12975.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 22:47:25 +0100
Message-Id: <1193348845.5697.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 23:35 +0200, Ingo Oeser wrote:
> On Thursday 25 October 2007, Kristen Carlson Accardi wrote:
> > Enable enclosure management via LED
> > 
> > As described in the AHCI spec, some AHCI controllers may support 
> > Enclosure management via a variety of protocols.  This patch
> > adds support for the LED message type that is specified in 
> > AHCI 1.1 and higher.
> 
> Linux has a LED subsystem for that. May I suggest, that you just register
> these leds and let userspace handle them via that via the LED API?
> 
> The LED userspace API is described in Documentation/leds-class.txt
> and the headers for registering LEDs is linux/leds.h under include/
> 
> Since you explicitly WANT user space to control these, that should
> be the right API. 
> 
> Richard, what do YOU think?

If you're exporting LEDs to userspace, the LED API was designed to do
just that...

Cheers,

Richard



