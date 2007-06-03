Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbXFCW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbXFCW7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXFCW7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:59:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34413 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbXFCW7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:59:14 -0400
Date: Mon, 4 Jun 2007 00:59:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/2] PM: Introduce hibernation and suspend notifiers
Message-ID: <20070603225903.GC2971@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200706020243.20117.rjw@sisk.pl> <20070603164143.GB4093@ucw.cz> <200706040038.54161.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706040038.54161.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 00:38:53, Rafael J. Wysocki wrote:
> On Sunday, 3 June 2007 18:41, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Make it possible to register hibernation and suspend notifiers, so that
> > > subsystems can perform hibernation-related or suspend-related operations that
> > > should not be carried out by device drivers' .suspend() and .resume() routines.
> > 
> > One more question: what will we call in suspend-to-both case? I do not
> > think we can call SUSPEND_PREPARE with frozen tasks, so just one call
> > to HIBERNATION_PREPARE?
> 
> Yes, right now it should work this way.

(Should it be mentioned in docuementation?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
