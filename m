Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbXGLUjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbXGLUjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXGLUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:38:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36653 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932483AbXGLUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:38:56 -0400
Date: Thu, 12 Jul 2007 10:54:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Message-ID: <20070712085428.GA1866@elf.ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <20070711111350.GI7091@elf.ucw.cz> <1184257734.9346.76.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184257734.9346.76.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Looks interesting... but I was feeling strange dejavu reading
> > this... and that's because you pasted the changelog twice :-).
> > 
> 
> Sorry, I should have re-checked the mail before sending out.

Were your patches enough to get hibernation working? I got kexec to
work here, so I guess I'm one step closer...

...video does not work in the kexec-ed kernel, unless I boot with
vga=1.

> > How fast can kexec boot secondary kernel?
> 
> I measure it on my IBM T42 with CONFIG_PRINTK_TIME=y. The boot-up time
> is about 4.35s from kexec is issued to root mounted in kexec kernel.

Not bad...

> > > 2. Compile the kexec-tools with kdump and kjump patches added, the
> > >    kdump patch can be found at:
> > > 
> > > http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch
> > 
> > I got 404 error :-(.
> 
> Sorry, typo problem. The URL should be:
> http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-kdump10.patch

That works, thanks.

> > > 7. In the kexec booted kernel, trigger the jumping back with following
> > >    shell command.
> > > 
> > >    echo <a>:<b> > /sys/power/resume
> > > 
> > >    Where <a> and <b> is non-negative integer, at least one of them must
> > >    be non-zero.
> > 
> > What does a and b mean?

> a and b has no meaning. They are only used to trigger the resume
> process. This will be fixed in the future version.

Ok.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
