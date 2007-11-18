Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXKRMi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXKRMi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 07:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXKRMiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 07:38:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1175 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbXKRMiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 07:38:17 -0500
Date: Sun, 18 Nov 2007 10:52:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tomas Carnecky <tom@dbservice.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
Message-ID: <20071118105214.GB7299@ucw.cz>
References: <473730F6.2010900@dbservice.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473730F6.2010900@dbservice.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> echo disk > /sys/power/state
> 
> successfully saves that state to the disk, but just as the laptop is
> about to turn itself off, it reboots (successfully, so the
> hibernation/resume process works well, even with X running! which is
> awesome :) ). But I'd rather like the computer turned off after I
> hibernate it. Where could the problem be?
> 
> It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
> days, both suspend and hibernate worked there (with one or two crashes,
> probably due to X, I've read that the intel driver got some
> suspend/resume improvements recently). Now I'm running gentoo, kernel
> 2.6.24-rc2. I'm using newer versions of almost all software now compared
> to the ubuntu system.

If it works in older ubuntu, you can probably do bisect. Does normal
shutdown work? You can try platform vs. shutdown mode...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
