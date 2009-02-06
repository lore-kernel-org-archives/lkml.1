Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZBFNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZBFNyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZBFNxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:53:50 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41200 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbZBFNxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:53:49 -0500
Date: Fri, 6 Feb 2009 14:53:43 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Jean Pihet <jpihet@mvista.com>, tony@atomide.com
Cc: Paul Walmsley <paul@pwsan.com>, Andrew Morton <akpm@linux-foundation.org>,
       ext-adrian.hunter@nokia.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, jarkko.lavinen@nokia.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Message-ID: <20090206145343.2b8a5353@mjolnir.drzeus.cx>
In-Reply-To: <200902061422.32689.jpihet@mvista.com>
References: <20081207213617.10456.43951.stgit@localhost>
	<20090205121045.4022c319.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com>
	<200902061422.32689.jpihet@mvista.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 14:22:32 +0100
Jean Pihet <jpihet@mvista.com> wrote:

> On Thursday 05 February 2009 21:32:03 Paul Walmsley wrote:
> > On Thu, 5 Feb 2009, Andrew Morton wrote:
> > > An infinite loop which assumes the hardware is perfect is always a
> > > worry.  But I see the driver already does that, so we're no worse off..
> Do you want a finite loop with udelay in it? I located 4 places were this 
> could be used. If so I can generate a new patch for that.
> 

Even if Andrew doesn't, I'd sure like it. (the finite bit at least) :)


Related, who is the maintainer of this driver? Tony? I'd like to have
someone who checks patches before I queue them up.


Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
