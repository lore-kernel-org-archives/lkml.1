Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbZHZNVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbZHZNVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZHZNVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:21:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55026 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbZHZNVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:21:10 -0400
Date: Wed, 26 Aug 2009 15:20:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Message-ID: <20090826132048.GC1505@ucw.cz>
References: <200908170215.21173.rjw@sisk.pl> <Pine.LNX.4.44L0.0908180954210.2995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908180954210.2995-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * Added [2/7] adding a framework for representing PM link (idea described
> >   in the patch message).
> > 
> > * [3/7] is the async resume patch (idea described in the patch message).
> > 
> > * [4/7] is the async suspend patch.
> > 
> > * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> > 
> > The patches have been tested on HP nx6325.
> > 
> > Comments welcome.
> 
> I'm not sure about the design of these things.  How much do we care 
> about wasting memory?  Your scheme allocates six pointers for every 
> dependency, plus four pointers for every device.  It's possible to 
> reduce this considerably, especially if the parent-child dependencies 
> aren't stored explicitly.

I'd say that this level of memory waste is perfectly acceptable...

							Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
