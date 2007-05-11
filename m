Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXEKXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXEKXXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbXEKXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:23:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51317 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755556AbXEKXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:23:29 -0400
Date: Sat, 12 May 2007 01:23:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Coywolf Qi Hunt <coywolf@gmail.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Message-ID: <20070511232326.GB28092@elf.ucw.cz>
References: <200611011323.14830.rjw@sisk.pl> <200705111121.51704.rjw@sisk.pl> <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org> <200705112208.53971.rjw@sisk.pl> <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Just to clarify, the change in question isn't new.  It was introduced by the
> > commit 9185cfa92507d07ac787bc73d06c42222eec7239 before 2.6.20, at Seife's
> > request and with Pavel's acceptance.
> 
> Ok, if it's that old, we migt as leave it in. Clearly there weren't many 
> regressions, and this isn't a case of other monsters lurking behind a lack 
> of testers.

Ok, so what is the result?

"platform" is the correct default, because it is as the spec said.

Both were default in recent history, and neither is too horrible. So
I'd prefer "platform" to be default, as it is correct.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
