Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZGNQFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZGNQFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZGNQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:05:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:55136 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbZGNQFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:05:24 -0400
Date: Tue, 14 Jul 2009 09:04:47 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix hardlink count on device_move
Message-ID: <20090714160447.GA1933@suse.de>
References: <4A5CAA9F.1050302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5CAA9F.1050302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 05:56:15PM +0200, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Update directory hardlink count when moving kobjects to a new parent.
> Fixes the following problem which occurs when several devices are
> moved to the same parent and then unregistered:
> 
> > ls -laF /sys/devices/css0/defunct/
> > total 0
> > drwxr-xr-x 4294967295 root root    0 2009-07-14 17:02 ./
> > drwxr-xr-x        114 root root    0 2009-07-14 17:02 ../
> > drwxr-xr-x          2 root root    0 2009-07-14 17:01 power/
> > -rw-r--r--          1 root root 4096 2009-07-14 17:01 uevent
> 
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Thanks for the patch.

Is this something new in 2.6.31-rc, or does it also show up in .30
and/or .27?

thanks,

greg k-h
