Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXIKQ0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXIKQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXIKQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:26:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbXIKQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:26:27 -0400
Date: Tue, 11 Sep 2007 18:27:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>, nigel@suspend2.net,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix failure to resume from initrds.
Message-ID: <20070911162719.GA26206@elf.ucw.cz>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111355.07369.rjw@sisk.pl> <200709111512.35348.rjw@sisk.pl> <200709111523.33968.rjw@sisk.pl> <alpine.LFD.0.999.0709110736440.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709110736440.16478@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Anyway, yes, init is freezable, but should it be?
> > > 
> > > I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?
> > 
> > Argh, no.  PF_NOFREEZE is inherited by the children.
> 
> Umm. All of this is __init code - why is freezability even an issue? We 
> shouldn't be suspending at this point anyway afaik..

We want to do resume sometime around here, and resume wants to run
with userspace frozen, as does suspend.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
