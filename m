Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZB0KK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZB0KK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZB0KKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:10:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43367 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZB0KKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:10:15 -0500
Date: Fri, 27 Feb 2009 11:12:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve Hj?nnev?g <arve@android.com>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227101247.GF4582@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902210057.27781.rjw@sisk.pl> <d6200be20902201708g45540f60ib024c3365c85aef4@mail.gmail.com> <200902211047.26787.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902211047.26787.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And if the kernel is supposed to start automatic suspend, it has to monitor
> > > all of the wakelocks.  IMO, it's better to allow the power manager to poll the
> > > kernel if it refuses to suspend.
> > 
> > What is better about polling in userspace?
> 
> One kernel thread less, for example?

One kernel thread is about as costly as one userland thread. And I
believe we should not design new code that _needs_ polling.

I think it is better to have kernel thread than userland polling us
all the time.

Now... on PC it will be "interesting". Your solution has great
advantage of being able to work with s2ram quirks... But s2ram quirks
are not an issue on embedded hardware or OLPC, and hopefully kernel
mode setting will fix it on PCs, too...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
