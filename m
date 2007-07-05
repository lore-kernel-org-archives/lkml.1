Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXGESgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXGESgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXGESgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:36:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759969AbXGESgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:36:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 5 Jul 2007 20:43:44 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050910.21852.nigel@nigel.suspend2.net> <20070704232513.GA2695@elf.ucw.cz>
In-Reply-To: <20070704232513.GA2695@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707052043.45499.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 01:25, Pavel Machek wrote:
> 
> > > > > > Beep_flags should be removed too if you're sticking with /proc.
> > > > > 
> > > > > Fixed.
> > > > 
> > > > Ta.  But you didn't answer the question - why /proc and not sysfs?
> > > 
> > > Do you seriously advocate setting two bits of one variable from /proc,
> > > and one more bit from /sys?
> > 
> > That's partly why I had a separate variable - retaining proc only because it's 
> > existing functionality, using sysfs for the new code. Remember, too, that 
> 
> /proc is not deprecated _that_ much, and notice that this is sysctl,
> not regular procfs code.
> 
> Yes, I see why you did it that way, but I also think you overdisgned
> it a bit. 

Hmm, what about adding a second interface to acpi_realmode_flags in sysfs, in
a separate patch, and scheduling the old one, in /proc, for removal?

Greetings,
Rafael 


-- 
"Premature optimization is the root of all evil." - Donald Knuth
