Return-Path: <linux-kernel-owner+w=401wt.eu-S1422845AbXBAMty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422845AbXBAMty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422846AbXBAMty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:49:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44007 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422845AbXBAMty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:49:54 -0500
Date: Thu, 1 Feb 2007 13:49:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070201124937.GA1991@elf.ucw.cz>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <200701300357.34304.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701300357.34304.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If we prove that Windows doesn't use the second either then it means
> they enumerate processors  via the DSDT -- which means bringing up
> the ACPI interpreter before bringing up SMP -- and that would require
> a significant change to Linux boot sequence...

Well, as we can do cpu hotplug these days... we could do this. Just
boot up with single cpu, then bring up additional cpus at runtime...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
