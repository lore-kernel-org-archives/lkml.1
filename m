Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXFMWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXFMWIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXFMWIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:08:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52839 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754384AbXFMWIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:08:13 -0400
Date: Thu, 14 Jun 2007 00:08:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Seyfried <seife@suse.de>
Cc: linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH, 2nd try] make disable_console_suspend runtime configurable
Message-ID: <20070613220800.GD2611@elf.ucw.cz>
References: <20070613200303.GB11437@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613200303.GB11437@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I hate having to recompile the kernel, just to be able to debug suspend.
> Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> /sys/power/disable_console_suspend.

> Signed-off-by: Stefan Seyfried <seife@suse.de>
> Signed-off-by: Frank Seidel <fseidel@suse.de>

I wonder if there's a better name?

Or maybe this should not be /sys configurable, but just have value for
each console "this console can work while suspended"?

(serial can, vesafb can, netconsole can't)?

Exporting "crash-me" option to user does not seem that cool to me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
