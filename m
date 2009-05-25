Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZEYMoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZEYMoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZEYMoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:44:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZEYMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:44:03 -0400
Date: Mon, 25 May 2009 14:43:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090525124358.GB13446@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop> <200905090143.10980.rjw@sisk.pl> <1243245907.16743.101.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243245907.16743.101.camel@nigel-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Oh, before I forget to mention and you ask - how to know what allowance
> for the drivers? I use a sysfs entry - the user then just needs to see
> what's needed on their first attempt, set up a means of putting that
> value in the sysfs file in future (eg /etc/hibernate/tuxonice.conf) and
> then forget about it.

I do believe needed ammount of memory can differ between between
different suspend attempts. I'd say difference between no X, X w/ 3D,
X w/ active 3D could be significant.

Plus... swsusp gets without configuring that, and I'd prefer as little
tunables as possible. (In swsusp case, 4MB is reserved for drivers,
and it is a bug if they need more).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
