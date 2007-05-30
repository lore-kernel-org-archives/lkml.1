Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbXE3WaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbXE3WaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXE3WaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:30:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43046 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017AbXE3WaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:30:00 -0400
Date: Thu, 31 May 2007 00:29:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Message-ID: <20070530222956.GD27309@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <20070530153740.GA4772@ucw.cz> <200705302244.25927.rjw@sisk.pl> <200705302311.40123.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705302311.40123.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think the rule should be: If you need to do something _before_ tasks are
> > frozen, do it in PM_PRE_FREEZE, but if you can do that after the tasks have
> > been frozen, do it on PM_HIBERNATION_PREPARE (or PM_SUSPEND_PREPARE in the
> > suspend case).
> 
> OTOH, having considered it for a while, I think that for now I can add just
> PM_PRE_FREEZE and PM_POST_THAW, as I don't have any user for the other ones.
> The other events may be added in the future if need be (along with some users).
> 
> I'll post revised patches in a new thread.

Yes please.

(Hmm, but you may create 4 of them PM_PRE_HIBERNATION, PM_PRE_SUSPEND,
PM_POST_HIBERNATION, PM_POST_SUSPEND -- I'd call all of them before
freeze and after thaw, but if we drop freezer for suspend, we won't
have to rename anything.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
