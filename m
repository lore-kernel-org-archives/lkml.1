Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYGNN7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYGNN7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYGNN7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:59:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753580AbYGNN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:59:11 -0400
Date: Mon, 14 Jul 2008 09:59:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
In-Reply-To: <alpine.LFD.1.10.0807131230130.2959@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0807140955020.2566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Linus Torvalds wrote:

> 
> 
> On Sun, 13 Jul 2008, Rafael J. Wysocki wrote:
> > 
> > Regressions with patches
> > ------------------------
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11072
> > Subject		: scsi-layer crash after usb storage device unplug
> > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > Date		: 2008-07-12 01:50 (2 days old)
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11072#c3
> 
> Alan, Greg?

We haven't heard back yet from Johannes to confirm that the fix really
works.  If it does, IMO the patch should go into 2.6.26.1.

(In fact it might not be so easy to tell, since the failure is caused 
be a race.  Perhaps it would be best to submit the patch in any case.)

Alan Stern

