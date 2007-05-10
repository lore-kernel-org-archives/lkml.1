Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbXEJOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbXEJOLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXEJOLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:11:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:56779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXEJOLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:11:32 -0400
Date: Thu, 10 May 2007 07:12:21 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: paulus@samba.org, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] update sysfs kset initialisation in PPC64 DLPAR IO
	driver
Message-ID: <20070510141221.GA26709@suse.de>
References: <464322F3.3010808@shadowen.org> <2c705c055fcd12202673ee8a3056153b@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c705c055fcd12202673ee8a3056153b@pinky>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:00:50PM +0100, Andy Whitcroft wrote:
> 
> Move the rpadlpar device from "struct subsystem" to "struct kset"
> following the changes in sysfs.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> 
> 	Ok, this patch seems to sort out the compile problem
> 	here and indeed boots and runs kernbench.  Perhaps
> 	you could confirm this is sufficient.

As per the discussion on the pci hotplug list, no, this doesn't seem to
fix the problem.  The developers there are looking into it.  If you can
test out patches for this, I'm sure the people there would appreciate
the help.

thanks,

greg k-h
