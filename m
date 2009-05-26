Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZEZJU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZEZJU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZEZJUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:20:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43243 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZEZJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:20:48 -0400
Date: Tue, 26 May 2009 11:19:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, nigel@tuxonice.net,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090526091940.GA29867@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905252343.23744.rjw@sisk.pl> <200905260045.33902.oliver@neukum.org> <200905260058.54482.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905260058.54482.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If you really have drivers that have exceptionally large memory requirements
> > (eg. you need to copy video ram), you should tell the system through struct
> > driver and do accounting at probe and removal of devices.
> 
> Or perhaps the drivers should allocate memory from a PM notifier (which is
> called before the freezing of tasks) to avoid the problem?

Yes, that's how it should work for big allocations.

For small allocations... I still believe we should free a bit of
memory for s2ram so that small allocations can be done without
problems.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
