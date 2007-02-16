Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXBPK7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXBPK7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945954AbXBPK7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:59:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55911 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933001AbXBPK7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:59:49 -0500
Date: Fri, 16 Feb 2007 11:59:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan Dittmer <jdi@l4x.org>, seife@novell.com
Cc: Mattia Dongili <malattia@linux.it>, stelian@popies.net,
       linux-acpi@vger.kernel.org, linux-pm@osdl.org, adaplas@pol.net,
       dawes@xfree86.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
Message-ID: <20070216105931.GE4176@elf.ucw.cz>
References: <45D43489.3060409@l4x.org> <20070215103639.GB27338@elf.ucw.cz> <37556.85.47.20.193.1171540572.squirrel@picard.linux.it> <45D558D6.3050303@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D558D6.3050303@l4x.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Thu, February 15, 2007 11:36 am, Pavel Machek said:
> 
> >>>     sys_vendor   = "Sony Corporation    "
> >>>     sys_product  = "PCG-SRX51P(DE)      "
> >>>     sys_version  = "01                  "
> >>>     bios_version = "R0232U2"
> >>>
...
> >>> Latest kernel I tested is 2.6.20-git11 from today.
> > 
> > I read reports of successful suspends on that laptop, eg:
> > http://freenet-homepage.de/obauer/index.html
> 
> Ok, now I feel totally dumb. 's2ram -s -f' actually works iff you disable
> fb support completely in the kernel. It works even from X. Don't know how
> many combinations I tried but that one somehow slipped through. Anyway
> thanks for your help. So could this machine be added to the s2ram
> database?

Stefan, can we add this one?

Anyway, it would be nice to actually fix the fb support in kernel not
to hang the machine on your Sony...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
