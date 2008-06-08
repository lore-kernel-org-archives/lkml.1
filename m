Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYFHEiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYFHEiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 00:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYFHEiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 00:38:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYFHEiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 00:38:10 -0400
Date: Sat, 7 Jun 2008 21:34:05 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Top kernel oopses/warnings for the week of Friday June 6th,
	2008
Message-ID: <20080608043405.GC21251@kroah.com>
References: <484988C8.1080105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484988C8.1080105@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:58:16AM -0700, Arjan van de Ven wrote:
>
> Rank 4: sysfs_add_one (warning)
> 	Reported 242 times (992 total reports)
> 	Duplicate sysfs registration in various components. We don't seem to be 
> making progress on this
> 	one unfortunately.
> 	This warning was last seen in version 2.6.26-rc3, and first seen in 
> 2.6.24-rc6.
> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

I really think this is solved for the USB subsystem at the least.  This
will be hit by other code under development at times, when the developer
gets something wrong.

If it does show up post 2.6.26-rc3 for the USB subsystem, please let me
know.

thanks,

greg k-h
