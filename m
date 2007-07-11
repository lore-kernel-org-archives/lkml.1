Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXGKVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXGKVtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbXGKVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:49:39 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:46551 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbXGKVti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:49:38 -0400
Date: Wed, 11 Jul 2007 22:48:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: do not add port that is not initialized
Message-ID: <20070711214842.GE2301@flint.arm.linux.org.uk>
References: <200707101703.36173.yinghai.lu@sun.com> <20070711071742.GA12952@flint.arm.linux.org.uk> <200707111005.53836.bjorn.helgaas@hp.com> <20070711194050.GB28258@flint.arm.linux.org.uk> <46954150.7050707@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46954150.7050707@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 01:45:04PM -0700, Yinghai Lu wrote:
> Russell King wrote:
> >Indeed, and since distros still haven't picked up my setserial v3,
> >I see little chance of that ever being practical.  Not that I've
> >really tried very hard to get them to - no real idea who to contact
> >to make that happen, and of course I've no interest in making it
> >happen anymore.
> 
> so remove these extra phantom devices, the kernel distros will use your 
> setserial v3.

You made a connection which wasn't there - setserial v3 doesn't allow
this either, but it is a cleaner and slightly more extensible
implementation of setserial v2.

It does, however, drop support for the things which 2.6 kernels don't
support, such as the setting of the multiport addresses and masks.  So
it wouldn't be suitable for shipping as-is with (eg) 2.4 kernels.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
