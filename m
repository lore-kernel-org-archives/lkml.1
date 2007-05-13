Return-Path: <linux-kernel-owner+w=401wt.eu-S1761709AbXENBmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761709AbXENBmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbXENBmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:42:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbXENBmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:42:23 -0400
Date: Sun, 13 May 2007 02:27:01 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       marcel@holtmann.org
Subject: Re: [BUG] usb/core/hub.c loops forever on resume from ram due to
	bluetooth
Message-ID: <20070513092701.GD11249@suse.de>
References: <4637CD25.5070104@rtr.ca> <464080C1.6010105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464080C1.6010105@rtr.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 09:53:05AM -0400, Mark Lord wrote:
>  Greg ?
> 
>  The oddball thing here is that on a UP machine with a UP kernel,
>  this (below) was never an issue.
> 
>  After moving the drive to a dual-core machine and rebuilding
>  the kernel with SMP=y, the problem becomes a killer here.
>  The two machines are nearly identical, apart from the CPUs.
> 
>  The failing machine is a Dell Inspiron 9400,
>  and mine isn't the only unit that has this issue.

Ok, I'll take a patch to keep the loop from going forever, but the main
issue here is that there is probably a hardware failure somewhere.

Care to resend the patch with proper formatting?

thanks,

greg k-h
