Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYABWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYABWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYABWCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:02:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43787 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYABWCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:02:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: freeze vs freezer
Date: Wed, 2 Jan 2008 23:04:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <20080102160234.GA17070@ucw.cz> <477C0258.8080609@nigel.suspend2.net>
In-Reply-To: <477C0258.8080609@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801022304.19279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Nigel Cunningham wrote:
> Hi.
> 
> Pavel Machek wrote:
> > Hi!
> > 
> >>>>>> So how do you handle threads that are blocked on I/O or a lock  
> >>>>>> during the system freeze process, then?
> >>>>> We wait until they can continue.
> >>>> So if I have a process blocked on an unavilable NFS mount, I can't
> >>>> suspend?
> >>> That's correct, you can't.
> >>>
> >>> [And I know what you're going to say. ;-)]
> >> Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE"  
> >> instead of a zero preempt_count()?  Really what we should do is just  
> >> iterate over all of the actual physical devices and tell each one  
> >> "Block new IO requests preemptably, finish pending DMA, put the  
> >> hardware in low-power mode, and prepare for suspend/hibernate".  As  
> >> long as each driver knows how to do those simple things we can have  
> >> an entirely consistent kernel image for both suspend and for  
> >> hibernation.
> > 
> > "each driver" means this is a lot of work. But yes, that is probably
> > way to go, and patch would be welcome.
> 
> Yes, that does work. It's what I've done in my (preliminary) support for
> fuse.

Hmm, can you please elaborate a bit?

Rafael
