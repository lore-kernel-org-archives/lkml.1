Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZB0KOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZB0KOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZB0KNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:13:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35507 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZB0KNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:13:54 -0500
Date: Fri, 27 Feb 2009 11:16:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227101632.GG4582@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0902211135170.7396-100000@netrider.rowland.org> <200902212214.59660.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902212214.59660.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> To summarize, we can:
> * Use a refcount such that automatic suspend will only be possible if it's
>   equal to zero (but that need not be the only criterion).
> * Use a per-device flag in dev_pm_info that will be set whenever the device
>   driver increases the refcount and unset whenever the driver decreases the
>   refcount.
> * Use a per-process flag that will be set whenever the process increases the
>   refcount and unset whenever the process decreases the refcount.

Yes, that sounds sane, and that's how reasonable wakelock
implementation should look like.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
