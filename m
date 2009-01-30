Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZBCNKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZBCNKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZBCNKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:10:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50779 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZBCNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:10:06 -0500
Date: Fri, 30 Jan 2009 21:49:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@Opfer-Online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090130204955.GC1253@ucw.cz>
References: <20090128113809.GA29424@elf.ucw.cz> <20090128194723.GA1394@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128194723.GA1394@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-01-28 19:47:23, Russell King wrote:
> On Wed, Jan 28, 2009 at 12:38:09PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > 2.6.29-rc1 was great step forward over previous kernels: it not only
> > displays something on screen but also mounts root
> > filesystem. Unfortunately it then panics with "attempted to kill
> > init".
> 
> > I tried both with CONFIG_EABI=N and  CONFIG_EABI=Y, OABI_COMPAT=Y. Any
> > more tricks I should try?
> 
> Don't enable EABI unless you have changed userspace to be EABI compliant.
> Also check that you have NWFPE enabled if you're not using a soft-float
> userspace.

Probleem seems to be fixed in 2.6.29-rc3. 2.6.28 also works... (but
won't charge the battery :-().

> You could also build the kernel with DEBUG_USER enabled and pass
> user_debug=-1 on the kernel's command line, and see if you get any more
> information.

Thanks for support!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
