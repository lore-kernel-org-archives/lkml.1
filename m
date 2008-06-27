Return-Path: <linux-kernel-owner+w=401wt.eu-S1763392AbYF0SWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392AbYF0SWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762114AbYF0SVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:21:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:33344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762095AbYF0SVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:21:16 -0400
Date: Fri, 27 Jun 2008 11:18:33 -0700
From: Greg KH <gregkh@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, yhlu.kernel@gmail.com,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: x86: Add /sys/firmware/memmap
Message-ID: <20080627181833.GA7735@suse.de>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214565175-21512-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:12:53PM +0200, Bernhard Walle wrote:
> This patch series adds a new interface /sys/firmware/memmap to export
> the BIOS (Firmware) provided memory map via sysfs for usage with
> kexec.
> 
> While the first patch adds the generic interface, the second patch
> implements that interface for E820 on x86.
> 
> Change compared to previous commit:
> 
>  1. Comments from Greg KH.
>  2. Documentation.
> 
> The patch has been tested on i386 and x86_64 with success.
> 

Looks good, want me to take this through my tree (due to the firmware
core change)?  If so, can you get an ack on the x86 portion from the
respective people as well?

thanks,

greg k-h
