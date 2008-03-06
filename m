Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbYCFMB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbYCFMB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbYCFL7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:59:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40583 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469AbYCFL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:59:42 -0500
Date: Thu, 6 Mar 2008 12:58:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Message-ID: <20080306115859.GA18239@elf.ucw.cz>
References: <20080306102927.GA4434@elf.ucw.cz> <20080306111303.GA30687@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306111303.GA30687@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 12:13:03, Pavel Machek wrote:
> Hi!
> 
> > On amd 8-core system, I get crash on boot... Last messages:
> > 
> > Quad-Core AMD Opteron...
> > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
> > BUG: unable to handle kernel paging request at 00...005958
> > IP: __alloc_pages+0x38
> > ...
> > Call trace:
> > kmem_getpages
> > cache_grow
> > ____cache_alloc_node
> > cpuup_callback
> > kmem_cache_alloc_node
> > cpuup_callback
> > notifier_call_chain
> > _cpu_up
> 
> It crashes in 64-bit mode only, 32-bit works ok.

...and it is a regression from 2.6.24.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
