Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXCUW3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXCUW3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCUW3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:29:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60194 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933334AbXCUW3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:29:42 -0400
Date: Wed, 21 Mar 2007 23:29:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc4: extremely high power consumption
Message-ID: <20070321222938.GB6060@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Today I heard fans running a bit too much. I checked with top, and got
no obvious power hog. And now acpi battery says:

root@amd:/data/l/zaurus/oz.spitz.3541# cat
/proc/acpi/battery/BAT0/state
present:                 yes
capacity state:          ok
charging state:          discharging
present rate:            35248 mW
remaining capacity:      1850 mWh
present voltage:         14259 mV

...35W! This machine normally eats 14W.

Now it got better, I still see nothing at top... 22W. That's still 8W
more than it should be. What is going on?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
