Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXBDMxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXBDMxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXBDMxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:53:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42113 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309AbXBDMxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:53:30 -0500
Date: Sun, 4 Feb 2007 13:53:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070204125316.GA1945@elf.ucw.cz>
References: <20070126112837.059502fc.akpm@osdl.org> <20070203001745.GB1712@elf.ucw.cz> <20070204043929.GG5647@linux.vnet.ibm.com> <200702041208.56466.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702041208.56466.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > o	init/do_mounts_initrd.c line 57 handle_initrd().
> > > > 	This looks to be short term anyway, so OK to leave.
> > > > 	But does kernel_execve() clear PF_NOFREEZE?
> > > > 
> > > > 	But it should be OK to freeze the init process when doing CPU
> > > > 	hotplug ops, right?
> > > 
> > > That looks bogus. If it is short term, it can as well live _without_
> > > PF_NOFREEZE. Noone should suspend system at that stage, right?
> >
> > I agree that any attempt to freeze that early in boot would be
> > at best an act of extreme bravery!
> 
> This is needed so that the _resume_ works, when it's handled from the user land
> by our resume tool.  Currently, the resume code calls
> freeze_processes() too.

I do not understand... freeze_processes() always leaves curent process
running... why is it needed?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
