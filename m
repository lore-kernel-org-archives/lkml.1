Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZGONWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZGONWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGONW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:22:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZGONW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:22:29 -0400
Date: Wed, 15 Jul 2009 06:20:36 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix hardlink count on device_move
Message-ID: <20090715132036.GC9688@suse.de>
References: <4A5CAA9F.1050302@linux.vnet.ibm.com>
 <20090714160447.GA1933@suse.de>
 <4A5D9EB7.30603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5D9EB7.30603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:17:43AM +0200, Peter Oberparleiter wrote:
> Greg KH wrote:
> > On Tue, Jul 14, 2009 at 05:56:15PM +0200, Peter Oberparleiter wrote:
> >> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> >>
> >> Update directory hardlink count when moving kobjects to a new parent.
> >> Fixes the following problem which occurs when several devices are
> >> moved to the same parent and then unregistered:
> >>
> >>> ls -laF /sys/devices/css0/defunct/
> >>> total 0
> >>> drwxr-xr-x 4294967295 root root    0 2009-07-14 17:02 ./
> >>> drwxr-xr-x        114 root root    0 2009-07-14 17:02 ../
> >>> drwxr-xr-x          2 root root    0 2009-07-14 17:01 power/
> >>> -rw-r--r--          1 root root 4096 2009-07-14 17:01 uevent
> >> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> > 
> > Thanks for the patch.
> > 
> > Is this something new in 2.6.31-rc, or does it also show up in .30
> > and/or .27?
> 
> This is an old problem that existed since the introduction of 
> sysfs_move_dir() in 2.6.20.

Thanks for the info, I'll mark it as such.

greg k-h
