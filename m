Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbXIUJwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbXIUJwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXIUJv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:51:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47720 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbXIUJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:51:57 -0400
Date: Fri, 21 Sep 2007 11:49:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: nigel@suspend2.net
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20070921094908.GB20149@elf.ucw.cz>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <20070920100941.GA12157@atrey.karlin.mff.cuni.cz> <200709211024.35991.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709211024.35991.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Seems like good enough for -mm to me.

(For the record, I do not think this is going to be
hibernation-replacement any time soon. But it is functionality useful
for other stuff -- dump memory and continue -- and yes it may be able
to do hibernation in the long term.

It really comes from the other side of reliability:

* swsusp is "if your kernel is perfectly healthy, it will work"

while this, coming from kdump is

* "if your kernel is not completely trashed, it should work"

...which is why can't use swsusp to do dump memory and continue -- you
want to do dumps on "slightly broken" systems. And yes, as a
sideeffect it may be able to do hibernation... why not, lets see how
it works out).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
