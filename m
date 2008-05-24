Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYEXFfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYEXFfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYEXFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:35:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36838 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYEXFf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:35:28 -0400
Date: Fri, 23 May 2008 22:32:43 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080524053243.GA8723@kroah.com>
References: <4836EE8C.1010200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4836EE8C.1010200@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 09:19:24AM -0700, Arjan van de Ven wrote:
> Rank 2: sysfs_add_one
> 	Reported 264 times (528 total reports)
> 	Duplicate sysfs registration... mostly a GregKH bug ...
> 	This oops was last seen in version 2.6.26-rc3, and first seen in 
> 2.6.24-rc6.
> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Note, only the older 2.6.24 and possibly .25 versions of this are my
"fault", as those come from the usb core.  That's a bug that I thought
we fixed, and I can not duplicate it myself at all.

Other instances of this are real problems in other areas of the kernel
(like the pci hotplug drivers), and are not my fault :)

If anyone knows of a way to constantly reproduce this issue with a USB
device, please contact me and I'll work to resolve this.

Arjan, thanks a lot for these reports, I find them very useful.

thanks,

gerg k-h
