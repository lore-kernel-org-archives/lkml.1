Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXAVSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXAVSro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXAVSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:47:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2566 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932222AbXAVSrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:47:43 -0500
Date: Mon, 22 Jan 2007 13:25:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jean-Marc Valin <jean-marc.valin@usherbrooke.ca>
Cc: nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM generates oops and general protection fault
Message-ID: <20070122132545.GA4493@ucw.cz>
References: <45B422D3.9040409@usherbrooke.ca> <1169436221.2190.13.camel@nigel.suspend2.net> <45B448BA.70800@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B448BA.70800@usherbrooke.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > will be a device driver. Common causes of suspend/resume problems from
> > the list you give below are acpi modules, bluetooth and usb. I'd also be
> > consider pcmcia, drm and fuse possibilities. But again, go for unloading
> > everything possible in the first instance.
> 
> Actually, the reason I sent this is that when I showed the oops/gpf to
> Matthew Garrett at linux.conf.au, he said it looked like a CPU hotplug
> problem and suggested I send it to lkml. BTW, with 2.6.20-rc5, the
> suspend to RAM now works ~95% of the time.

Try a kernel without CONFIG_SMP... that will verify if it is SMP
related.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
