Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXELTl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXELTl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXELTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:41:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755932AbXELTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:41:18 -0400
Date: Sat, 12 May 2007 12:40:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <20070512191709.GA428@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705121239090.3986@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl>
 <20070512191709.GA428@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Pavel Machek wrote:
> 
> If you fail to do that, we'll see freezer failure, quickly, and catch
> the simple bug.

"It's a feature to add crap to drivers and subsystems that don't care!"

That's a novel thing.

Maybe we could add other features too. Like a "IM_NOT_AN_IDIOT" flag that 
every driver has to set in it's "struct device", so that the device 
manager knows that it wasn't written by an idiot.

> I'm afraid that if we default to "do not freeze by default", someone
> will just port zfs, will know nothing about suspend, and his 
> "write management info somewhere periodically" thread will corrupt
> people's disks.

Right. That's what the IM_NOT_AN_IDIOT thing will do too - it will 
guarantee that only smart people do the right thing.

Great idea. We'll get a better kernel in no tim!

		Linus
