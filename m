Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYLDLOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYLDLOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYLDLOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:14:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYLDLOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:14:31 -0500
Date: Thu, 4 Dec 2008 12:16:21 +0100
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
Message-ID: <20081204111621.GA2466@elf.ucw.cz>
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com> <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com> <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-24 19:17:44, Thomas Gleixner wrote:
> On Mon, 24 Nov 2008, Alexander Beregalov wrote:
> 
> > 2008/11/24 Alexander Beregalov <a.beregalov@gmail.com>:
> > > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > > hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> > > ODEBUG: object is on stack, but not annotated
> > > ------------[ cut here ]------------
> > > WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()
> > 
> > Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
> > (x86: HPET_MSI Initialise per-cpu HPET timers)
> > 
> > Revert helps
> 
> That's just a warning about a missing annotation. The commit is fine.

You must be using very different metric of what "fine" means than rest
of the world.

(No, introducing WARN_ON()s is not fine; it spams kerneloops.org at least...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
