Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBTSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBTSGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZBTSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:06:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZBTSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:06:08 -0500
Date: Fri, 20 Feb 2009 19:05:53 +0100
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090220180553.GB1490@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <200902161748.09208.oliver@neukum.org> <20090216093108.078aac35@infradead.org> <200902170020.15509.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902170020.15509.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-02-17 00:20:12, Oliver Neukum wrote:
> Am Monday 16 February 2009 18:31:08 schrieb Arjan van de Ven:
> > On Mon, 16 Feb 2009 17:48:06 +0100
> > Oliver Neukum <oliver@neukum.org> wrote:
> > 
> > > > Userspace should just be the part that says "I'm interested in link
> > > > notifications". The driver then just goes to the lowest power state
> > > > for its device that still gives those notifications.
> > > 
> > > Should there be a channel through which drivers can tell user space
> > > what the consequences in terms of reaching a sleep state are if a
> > > service is requested?
> > 
> > Personally, I don't think so.
> > Think about it: what would userspace do?
> > Not ask for the functionality if it means no sleep state?
> > Maybe it should just never ask for it then as a required functionality!
> 
> 1. You may have a human being using the information to make the tradeoff.
> 2. User space may be able to select among several devices the one cheapest
> to use

Well, that sounds complex/fragile... and it is really exporting
hardware impormation driver does not even neccessarily know.

If this is for user, perhaps it should be in documentation and/or
hardware user manual?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
