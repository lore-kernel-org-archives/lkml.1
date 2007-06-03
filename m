Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXFCQmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXFCQmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXFCQl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:41:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3505 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753396AbXFCQlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:41:55 -0400
Date: Sun, 3 Jun 2007 16:41:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/2] PM: Introduce hibernation and suspend notifiers
Message-ID: <20070603164143.GB4093@ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200706020241.53788.rjw@sisk.pl> <200706020243.20117.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706020243.20117.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make it possible to register hibernation and suspend notifiers, so that
> subsystems can perform hibernation-related or suspend-related operations that
> should not be carried out by device drivers' .suspend() and .resume() routines.

One more question: what will we call in suspend-to-both case? I do not
think we can call SUSPEND_PREPARE with frozen tasks, so just one call
to HIBERNATION_PREPARE?

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
