Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbXCTWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbXCTWSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCTWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:18:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59545 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbXCTWSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:18:04 -0400
Date: Tue, 20 Mar 2007 23:17:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] swsusp: Use GFP_KERNEL for creating basic data structures
Message-ID: <20070320221755.GP3545@elf.ucw.cz>
References: <200703122214.02657.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org> <200703202218.16820.rjw@sisk.pl> <200703202228.55012.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202228.55012.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make swsusp call create_basic_memory_bitmaps() before processes are frozen,
> so that GFP_KERNEL allocations can be made in it.  Additionally, ensure
> that the swsusp's userland interface won't be used while either
> pm_suspend_disk() or software_resume() is being executed.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK, but I'd prefer it to go before the bitmap patches, as it can be
viewed as bugfix... ok, it probably does not matter much in this case.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
