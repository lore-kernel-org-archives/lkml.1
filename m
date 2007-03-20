Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXCTMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXCTMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXCTMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:07:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52143 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753692AbXCTMHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:07:14 -0400
Date: Tue, 20 Mar 2007 13:06:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <len.brown@intel.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: s2ram autowake regression is still there in 2.6.21-rc4-git
Message-ID: <20070320120650.GA2578@elf.ucw.cz>
References: <20070320115657.GA4438@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320115657.GA4438@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Run this script. The s2ram at the end of it will wakeup immediately
> after going to sleep, bad. I tried reproducing it with smaller
> version, but was not too successful.

Actually

> sleep 2
> echo -n "testing swsusp (platform)..."
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing s2ram..."
> s2ram
> echo "okay"

...this is enough to trigger it. I've done my testing on x60, FWIW.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
