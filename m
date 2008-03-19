Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbYCSXZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbYCSXZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939504AbYCSV7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:59:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761336AbYCSV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:59:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation patchset against -rc6)
Date: Wed, 19 Mar 2008 22:58:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200803172317.33745.rjw@sisk.pl> <200803192243.14520.rjw@sisk.pl> <20080319215729.GF1811@elf.ucw.cz>
In-Reply-To: <20080319215729.GF1811@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192259.00091.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Pavel Machek wrote:
> 
> > > >> Revert ec.c to 2.6.25-rc5 state:
> > > >>
> > > >> * this fixes backlight after closing/reopening the lid while in X on
> > > >> thinkpad x60
> > > >>
> > > >> * unfortunately it breaks fn-home/end keyboard brightness control
> > > > It should also break volume up/down/mute keys. Essentially all the keys on Thinkpad.
> > > > And it would also be regression to 2.6.24 level.
> > > 
> > > As I explained above.
> > > 
> > > Unfortunately, applying this means I loose screen as soon as I
> > > close/reopen lid. 2.6.24 did not behave like that. And it makes my
> > > machine mostly unusable -- as soon as you try to carry it away, you
> > > loose video. BAD.
> > 
> > Can you text the current -git (preferably without anything on top) pretty please?
> 
> Did anything relevant change in the last 8 hours or so?

No, it didn't.

> My scripts tell me there's nothing to pull:
> 
> Done counting 441 objects.
> Result has 304 objects.
> Deltifying 304 objects.
>  100% (304/304) done
> Total 304, written 304 (delta 236), reused 121 (delta 75)
> Fetching pack (head and objects)...
> Fetching tags...
> Up to date.
> 
> Applying changes...
> Branch already fully merged.
> pavel@amd:~$

Still, the current -git has the offending patch reverted and you're seeing a
regression nevertheless.

Is that correct?

Rafael
