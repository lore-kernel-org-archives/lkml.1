Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbXGEWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbXGEWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbXGEWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:00:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58768 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760449AbXGEWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:00:51 -0400
Date: Fri, 6 Jul 2007 00:00:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>, nigel@suspend2.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Message-ID: <20070705220046.GC3881@elf.ucw.cz>
References: <200707041658.59588.rjw@sisk.pl> <200707051328.50845.rjw@sisk.pl> <200707052137.58164.nigel@nigel.suspend2.net> <200707052231.27780.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707052231.27780.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The syncing of filesystems from within the freezer is generally not needed.
> Change freeze_processes() so that it doesn't execute sys_sync() and make the
> suspend and hibernation code path sync filesystems independently of the freezer.

Yes, we can do that, but ... why?

Does it actually fix FUSE? Miklos claims sync is nop on FUSE...?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
