Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXCFIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXCFIWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXCFIWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:22:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36328 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752929AbXCFIWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:22:23 -0500
Date: Tue, 6 Mar 2007 09:22:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] libata: add missing PM callbacks
Message-ID: <20070306082212.GC2040@elf.ucw.cz>
References: <20070302083001.GK20322@htj.dyndns.org> <45E8B3C8.2090009@garzik.org> <45E8E749.4030406@gmail.com> <20070306080509.GA2040@elf.ucw.cz> <45ED22AB.4090901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED22AB.4090901@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Much complexity for little gain. Who is running _without_ CONFIG_PM
> > these days?
> 
> Embedded people, I guess.  The problem here is that if we are gonna
> support !CONFIG_PM configuration and try to reduce the kernel/module
> images size for such case, we end up sprinkling #ifdef's all over huge
> number of device drivers.

Ok, in separate mail I see you already did the work...

> If we determine to drop !CONFIG_PM configuration, I'm happy with that
> too but we need to determine something here.  Alternatives...
> 
> 1. drop !CONFIG_PM configuration
> 2. continue to sprinkle #ifdef's over device drivers
> 3. find out prettier way to mark PM functions

...of 3., and code is nicely generic and fairly simple. I thought it
would be too much work to implemente it, and it would get too messy.

Given that it is so simple, I believe 3. is the best option. We can
still do 1. in future if we feel like so...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
