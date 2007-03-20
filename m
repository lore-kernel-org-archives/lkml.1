Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXCTNSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXCTNSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbXCTNSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:18:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752661AbXCTNSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:18:41 -0400
Date: Tue, 20 Mar 2007 14:18:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Message-ID: <20070320131802.GC4996@elf.ucw.cz>
References: <200703122214.02657.rjw@sisk.pl> <200703122219.21171.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319173127.72c3419d.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The patch is designed to minimize the amount of changes and there are some nice
> > simplifications and optimizations possible on top of it.  I am going to
> > implement them separately in the future.
> 
> Blows up with ia64 allmodconfig due to CONFIG_PM=y, CONFIG_SOFTWARE_SUSPEND=n:
> 
> kernel/power/main.c:223: error: redefinition of 'software_suspend'
> include/linux/suspend.h:46: error: previous definition of 'software_suspend' was here
> 
> I had a look at fixing it, but it's unobvious why we're compiling most of
> kernel/power/main.c when CONFIG_SOFTWARE_SUSPEND=n so I'll send this series
> back for repair please.

main.c is needed for suspend-to-ram, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
