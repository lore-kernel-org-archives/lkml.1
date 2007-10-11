Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXJQNMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXJQNMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbXJQNL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:11:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3773 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755946AbXJQNLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:11:55 -0400
Date: Thu, 11 Oct 2007 21:19:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Message-ID: <20071011211949.GA4151@ucw.cz>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos> <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos> <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org> <18163.19912.127570.192406@cargo.ozlabs.ibm.com> <1190361975.3085.106.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190361975.3085.106.camel@chaos>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-09-21 10:06:15, Thomas Gleixner wrote:
> On Fri, 2007-09-21 at 14:51 +1000, Paul Mackerras wrote:
> > Linus Torvalds writes:
> > 
> > > It would indeed be nice if we could just take CPU's down early (while 
> > > everything is working), and run the whole suspend code with just one CPU, 
> > > rather than having to worry about the ordering between CPU and device 
> > > takedown.
> > 
> > That is certainly what we want to do on powerpc.
> 
> I would have expected that we do it exactly this way and it took me by
> surprise, that we do not.

Well, we used to do that, but acpi spec forbids that, and it means
userspace sees plugs/unplugs.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
