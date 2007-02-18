Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbXBRM4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbXBRM4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXBRM4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:56:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59921 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXBRM4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:56:33 -0500
Date: Sun, 18 Feb 2007 13:56:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070218125610.GA16349@elf.ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702151431.10068.rjw@sisk.pl> <20070215142542.GA14931@in.ibm.com> <200702171224.46626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702171224.46626.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So I think tonight I'll start adding try_to_freeze() to the kernel threads that
> > > set PF_NOFREEZE.
> > 
> > cool! While you are at it, let me try to enhance the freezer api's
> > to incorporate the PFE_* flags.
> 
> Here's a patch that adds try_to_freeze() to all kernel threads that didn't call
> it before.  It shouldn't change the behavior of the threads in question, since
> they won't be frozen because the are flagged as PF_NOFREEZE (of course
> we are going to change this later).

Looks ok.

> Compile-tested on x86_64 with allmodconfig.
> 
> Pavel, do you think we can remove the PF_NOFREEZE from bluetooth,
> BTW?

Yes... bluetooth has no reason to play with NOFREEZE.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
