Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYEYRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYEYRiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYEYRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:38:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1724 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753761AbYEYRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:38:43 -0400
Date: Sun, 25 May 2008 19:38:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SB600 AHCI: Hard Disk Corruption
Message-ID: <20080525173825.GA4132@ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211717435.6038.53.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've got an annoying problem with my athlon 64bit, 4gb ram, ???asus m2a-vm
> (->SB600 AHCI controller), SAMSUNG HD501LJ SATA Disk. I'm using kernel
> 2.6.26-rc3. Everything works fine, expect for standby/suspend/hibernate.
> Standby freezes, hibernate, I acually ???haven't tested lately cause I
> want suspend to ram to work first.
> 
> "echo mem > /sys/power/state; vbetool post;" (on text console)
> successfully suspends the system and it resumes as well, BUT: After
> resuming, things quickly turn bad: "file not fonund", kernel reports

iommu problem? Try it with mem=3G.

> * I read many threads in which Tejun provided patches for the SB600 AHCI
> Controller which seems to be seriously broken - if only i knew that in
> advance... Maybe he can fix this issue as well - last ressort. Otherwise
> I'll burn that mobo!

I suspect all you need is to burn one dimm.. or send it to me so that
I can reproduce it ;-).

> ???** After my firs install and configuring the system for a day, trying
> out suspend to ram smashed it with no backups, since then i didn't learn
> my lesson and smashed it again 2-3 times, this time with backups at hand
> though, ...

Boot it from cd ;-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
