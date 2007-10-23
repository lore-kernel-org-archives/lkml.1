Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXJXNNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXJXNNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXJXNMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:12:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4687 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbXJXNMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:12:52 -0400
Date: Tue, 23 Oct 2007 18:31:21 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071023183121.GA4898@ucw.cz>
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017212025.d8a52694.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This is a request to merge KGDB into the mainline kernel.  
> 
> This won't work very well.  There's a lot of review work to be done here,
> and a lot of it by busy architecture maintainers.  Expecting people to do
> all this review and test work late in the merge window when they're all
> madly scrambling to get their bugs^Wpatches into mainline is not reasonable.
> This should all have started a month ago.

_If_ the code is properly bisectable, it should be possible to merge
core now and then switch architectures lazily. (If it is not
bisectable, it should be fixed).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
