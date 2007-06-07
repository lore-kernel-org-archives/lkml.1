Return-Path: <linux-kernel-owner+w=401wt.eu-S937007AbXFGVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937007AbXFGVQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936974AbXFGVPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:15:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41936 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936945AbXFGVPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:15:31 -0400
Date: Thu, 7 Jun 2007 23:15:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Olaf Dietsche <olaf.dietsche@olafdietsche.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070607211523.GB8611@elf.ucw.cz>
References: <878xb35sje.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl> <87hcpr2ubl.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl> <87wsykpweu.fsf@goat.bogus.local> <20070607122303.GA8938@ucw.cz> <87tztjo7zo.fsf@goat.bogus.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tztjo7zo.fsf@goat.bogus.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-06-07 21:54:51, Olaf Dietsche wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> >> But either way the script never reaches "shutdown -rn now". So, it
> >> seems, that my laptop does a full resume every other reboot, but it
> >> never returns to userspace.
> >
> > But it returns to kernel... can you use more trace points to figure
> > out where it hangs?
> 
> I haven't looked, but I guess this is somewhere in sysfs.
> 
> I made some small progress. With the nvidia.ko kernel module loaded,
> my laptop returns to userspace. I'll investigate this further.

So it _was_ video card related :-). With working console, it should be
easy to debug with printk.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
