Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXCTT5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXCTT5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXCTT5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:57:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50438 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753809AbXCTT5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:57:08 -0400
Date: Tue, 20 Mar 2007 20:56:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070320195659.GA3545@elf.ucw.cz>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFF026.4030502@gmail.com> <20070320080944.9cb3c765.akpm@linux-foundation.org> <20070320183821.GD2670@elf.ucw.cz> <4600389E.6030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4600389E.6030901@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
> >> which will simply do a freeze/unfreeze cycle.  Then we can apply various
> >> workloads to the machine while madly stressing the freezer code.  
> > 
> > echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
> > pretty much what you want.
> 
> Ok, I'll try this.

It will not help you -- probably -- it is equivalent to just running
s2ram. But it should make "successful" testing easier, because you no
longer need machine with working suspend to test refrigerator.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
