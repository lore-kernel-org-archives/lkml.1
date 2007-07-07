Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXGGMJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXGGMJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXGGMJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:09:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46306 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753425AbXGGMJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:09:22 -0400
Date: Sat, 7 Jul 2007 14:09:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Mackerras <paulus@samba.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070707120919.GB3111@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707041310.11336.rjw@sisk.pl> <18059.33636.66185.902453@cargo.ozlabs.ibm.com> <200707041630.30048.rjw@sisk.pl> <18060.14341.341604.666867@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18060.14341.341604.666867@cargo.ozlabs.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-05 10:15:01, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > This is incompatible with the code in kernel/power/main.c, since we only
> > disable the nonboot CPUs after devices have been suspended.  Do you think that
> > your framework can be modified to work without disabling the nonboot CPUs
> > by the user space?
> 
> Sure.  It was a "if it can be done in userspace, do it in userspace"
> kind of decision, but I'm not wedded to it.
> 
> I actually do want to converge to using the generic suspend-to-ram
> code on powerbooks.  I just want to avoid causing regressions for
> powerbook users, including myself. :)

Curious, do you actually use fuse? Can you try it _with_ freezer and
produce sysrq-t trace of deadlock?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
