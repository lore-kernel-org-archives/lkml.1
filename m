Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbYCEWOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbYCEWOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763910AbYCEWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:14:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341AbYCEWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:13:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Date: Wed, 5 Mar 2008 23:12:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <20080305093610.GA700@atrey.karlin.mff.cuni.cz> <20080305093923.GA2049@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080305093923.GA2049@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803052312.37996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 of March 2008, Pavel Machek wrote:
> Hi!
> 
> > > (If I try to suspend to disk, I get a rather nasty oops; goes away
> > > with mem=3G. Related?)
> > 
> > The nasty oops is in swsusp_save+0x298 . 
> > 
> > rdx=0xffff810000001008 
> > rdi=0xffff81000c001008
> > rdi=0x0000000131613000
> 
> Rafael, this seems to be similar to some problem you were trying to
> solve... something with numa... I could not find it in
> bugzilla.kernel.org... do you remember details by chance?

http://bugzilla.kernel.org/show_bug.cgi?id=9966

[Just have a look at the list of regressions from 2.6.24. ;-)]

In fact, I didn't even try to solve it myself, but asked some knwoledgeable
people (CCed) for advice.  No one responded, unfortunately ...

Thanks,
Rafael
