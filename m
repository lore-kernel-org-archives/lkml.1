Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYFYKcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYFYKcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYFYKbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:31:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42348 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYFYKbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:31:52 -0400
Message-ID: <48621E83.3060608@pobox.com>
Date: Wed, 25 Jun 2008 06:31:31 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>, ben-linux@fluff.org
Subject: Re: Removal of BAST IDE driver
References: <20080625090953.GA26556@flint.arm.linux.org.uk> <200806251214.14749.bzolnier@gmail.com>
In-Reply-To: <200806251214.14749.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> series) so when later Jeff merged:
> 
> commit cc18e0fea7907e7a96b7df71b81838d518bc074e
> Author: Ben Dooks <ben-linux@fluff.org>
> Date:   Mon Jun 16 12:16:26 2008 +0100
> 
>     LIBATA: Add HAVE_PATA_PLATFORM to select PATA_PLATFORM driver
> ...
> 
> which was patch #1/2 in the series I was under impression that now we
> have both new and old driver with the old driver being the default because
> of the link order.  Seems I was wrong after all as other things are moving
> slower than IDE/ATA. ;)
> 
> Sorry for messing things up.  Russell/Ben: how should we proceed with
> fixing it (arch part in or ide part out)?


Ben's change merely adds a knob that a platform may set, in order to 
enable the existing pata_platform driver, which is pretty safe by itself.

The next piece -- once not in 2.6.26 AFAIK -- is arch-specific code 
selecting HAVE_PATA_PLATFORM.  BAST IDE, I assume, can go away once 
relevant platforms start turning on HAVE_PATA_PLATFORM.

	Jeff


