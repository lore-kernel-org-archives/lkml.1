Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZBPXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZBPXTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZBPXTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:19:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56397 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZBPXTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:19:03 -0500
Date: Tue, 17 Feb 2009 00:18:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
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
Message-ID: <20090216231850.GJ1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <200902162248.34287.rjw@sisk.pl> <20090216225116.GG1370@ucw.cz> <200902170000.43387.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902170000.43387.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-02-17 00:00:41, Rafael J. Wysocki wrote:
> On Monday 16 February 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > Userland should never ever control the state of a device like this
> > > > directly. It should do so by a) closing the device and b) setting
> > > > latency / functional requirements.
> > > 
> > > The user, however, may want to forcibly put a device into a low power state
> > > without stopping all of the applications that depend on it (eg. have it open).
> > > Do you think that we shouldn't allow users to do such things?
> > 
> > I don't think we should do this... of you want device to be powered
> > down, just don't keep it open. revoke should be enough :-).
> > 
> > ...one execption here is the disk driver; unmounting filesystems to
> > let the disk spin down is probably too heavy.
> 
> Well, I don't think it's viable to make any exceptions here.  Either we do it
> or we don't.  And the agreement appears to be that we don't.

We already have interface to force disk down (for disk protectioon
stuff), so this is already done for other reasons.

But in general, close(joystick) is nicer interface then 'echo
turn-off-joystick-even-when-open > /sys/somewhere'.
					

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
