Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbXFNWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbXFNWjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXFNWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:39:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53185 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXFNWjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:39:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH -mm 6/7] PM: Remove power_state.event checks from suspend core code
Date: Fri, 15 Jun 2007 00:46:12 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <200706131716.57915.rjw@sisk.pl> <200706140721.35478.david-b@pacbell.net>
In-Reply-To: <200706140721.35478.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150046.13650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 16:21, David Brownell wrote:
> On Wednesday 13 June 2007, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The suspend routines should be called for every device during a system sleep
> > transition, regardless of the device's state, so that drivers can regard these
> > method calls as notifications that the system is about to go to sleep, rather
> > than as directives to put their devices into the 'off' state.
> 
> Did you audit all the drivers to make sure this won't break things?
> Like for example through inappropriate pci_save_state() calls?

I did, but not very carefully.

> I'd really expect this patch would break things...

Well, in that case I'll have a closer look at them.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
