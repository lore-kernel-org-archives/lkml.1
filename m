Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0BWPBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:01:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:55681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab0BWPBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:01:49 -0500
Date: Tue, 23 Feb 2010 07:01:41 -0800
From: Greg KH <gregkh@suse.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: hjk@linutronix.de,
       "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: UIO support for >32-bit physical addresses on 32-bit platforms
Message-ID: <20100223150140.GA3781@suse.de>
References: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 08:54:16AM -0600, Kumar Gala wrote:
> Hans, Greg,
> 
> We are looking at using UIO for some driver work and noticed it
> assumes the address for MMIO regions is an 'unsigned long'.  This is a
> problem for the platforms we have in which we support a 36-bit
> physical address in a 32-bit machine.
> 
> Should we just change addr/size in struct uio_mem to u64 always?  At
> first I was thinking phys_addr_t but realized the addr could be PHYS,
> LOGICAL, or VIRTUAL.

I think that would work out fine, Hans, any ideas if this would cause
any problems with existing code or not?

thanks,

greg k-h
