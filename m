Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZJKI7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZJKI7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZJKI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:59:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZJKI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:59:50 -0400
Date: Sun, 11 Oct 2009 10:59:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
Message-ID: <20091011085859.GA1337@ucw.cz>
References: <cover.1254701151.git.joe@perches.com> <200910060037.57546.rjw@sisk.pl> <1255060436.16347.36.camel@Joe-Laptop.home> <200910102328.37108.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910102328.37108.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Here's the same patch redone against -next.
> > 
> > Added #define pr_fmt(fmt) "PM: " fmt
> > Converted printk(KERN_<level> to pr_<level>(
> > Converted printks without KERN_ to pr_info or pr_cont
> > Removed hard coded "PM: " prefix from message strings
> > Added pr_fmt() to __initdata strings
> > Integrated multiple line strings
> > All logging messages are now output prefixed with "PM: "
> 
> Does this patch depend on any other patch that haven't been merged yet?
> 
> I still don't like pr_info(), pr_error() and pr_crit().

Well, rest of kernel uses them, they are shorter, and will save few
bytes  too... so why not?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
