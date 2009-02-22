Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZBVNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZBVNqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZBVNqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:46:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34768 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBVNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:46:32 -0500
Date: Sun, 22 Feb 2009 14:46:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090222134618.GA1436@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <200902170026.06966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902170026.06966.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The recent descussion about the Android PM patches sent by Arve shows that
> > > there is a need to introduce a mechanism allowing us to:
> > > (1) automatically put the system as a whole into a sleep state (eg. suspend to
> > >     RAM) when it is found to be "idle", where the meaning of "idle" has to be
> > >     defined too,
> > 
> > Well; I'd prefer to keep the interface very minimal.
> > 
> > If no devices are being used,
> 
> We'll need some kind of infrastructure to detect such situations.

Yes, I like the latest 'atomic_t + bit in struct device' ideas...
 
> > and next wakeup is far enough in the future,
> 
> What exactly do you mean by "next wakeup"?

Next timer in kernel and next sleep/select timeout in userspace.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
