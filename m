Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYFHE4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYFHE4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 00:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYFHE4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 00:56:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYFHE4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 00:56:01 -0400
Date: Sat, 7 Jun 2008 21:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Top kernel oopses/warnings for the week of Friday June 6th,
 2008
Message-Id: <20080607215530.8ad82a7b.akpm@linux-foundation.org>
In-Reply-To: <20080608043405.GC21251@kroah.com>
References: <484988C8.1080105@linux.intel.com>
	<20080608043405.GC21251@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 21:34:05 -0700 Greg KH <greg@kroah.com> wrote:

> On Fri, Jun 06, 2008 at 11:58:16AM -0700, Arjan van de Ven wrote:
> >
> > Rank 4: sysfs_add_one (warning)
> > 	Reported 242 times (992 total reports)
> > 	Duplicate sysfs registration in various components. We don't seem to be 
> > making progress on this
> > 	one unfortunately.
> > 	This warning was last seen in version 2.6.26-rc3, and first seen in 
> > 2.6.24-rc6.
> > 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one
> 
> I really think this is solved for the USB subsystem at the least.  This
> will be hit by other code under development at times, when the developer
> gets something wrong.

For the sysfs vfs caches, yes.  But for sysfs pagecache (which I expect
is only symlinks?) the pages will still be on the LRU?

