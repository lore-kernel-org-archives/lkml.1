Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0CISOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:14:21 -0500
Received: from kroah.org ([198.145.64.141]:35734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab0CISOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:14:18 -0500
Date: Tue, 9 Mar 2010 10:14:13 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100309181413.GB31027@kroah.com>
References: <20100309174815.29339.96173.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309174815.29339.96173.stgit@bob.kio>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:52:43AM -0700, Alex Chiang wrote:
> While trying to render aid and assistance for a USB3 issue that Sarah
> has been chasing, she grumbled in a private email that she was unable
> to coerce the build system to produce a module named "xhci_hcd".
> 
> This patch series shows one way to get around the Makefile intrinsics
> and create a module name of our choosing. There's probably a better
> way to do it, but it's beyond my makefile-fu.
> 
> The other change is to move all the debug code under
> CONFIG_XHCI_HCD_DEBUGGING, which is a straightforward change.
> 
> Thanks,
> /ac
> 
> ---
> 
> Alex Chiang (2):
>       USB: xhci: rename driver to xhci_hcd

I'm not opposed to this at all, but note, we should do it _now_ and not
hold on to this patch for the rest of the .34 development cycle
otherwise people are going to have a lot of trouble merging patches.

Sarah, mind if I take this one patch?

>       USB: xhci: move all debug code under CONFIG_XHCI_HCD_DEBUGGING

Does this conflict with Sarah's other debugging patch she just sent out?

thanks,

greg k-h
