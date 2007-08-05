Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbXHESuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbXHESuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXHESt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:49:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44073 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751918AbXHEStz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:49:55 -0400
Date: Sun, 5 Aug 2007 20:50:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 1/1] Kexec jump - v2 - kexec jump
Message-ID: <20070805185008.GD1758@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com> <20070731095101.GA1774@elf.ucw.cz> <1185954978.1363.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185954978.1363.23.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This patch implement the functionality of jumping from kexeced kernel
> > > to original kernel.
> > > 
> > > A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
> > > trigger the jumping to (executing) the new kernel or jumping back to
> > > the original kernel.
> > 
> > Could we get two reboot commands? Exec loaded kernel seems to be quite
> > different operation than "jump back".
> 
> Exec loaded kernel for jumping back is also different from exec loaded
> kernel normally.
> 
> Maybe the two reboot operations in kexec jump can be seen as "jump to"
> and "jump back"?

Yes, that would be better.

> Document will be added in next version too.
> 
> This parameter is used for kernel-to-kernel communication. But now, it
> must be setup by user, as in usage guide.

Thanks for your help :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
