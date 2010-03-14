Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0CNSRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:17:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:48690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0CNSRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:17:20 -0400
Date: Sun, 14 Mar 2010 11:10:40 -0700
From: Greg KH <gregkh@suse.de>
To: Ossama Othman <ossama.othman@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Restricted Access Region Handler
Message-ID: <20100314181040.GB28359@suse.de>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 01:14:23AM -0800, Ossama Othman wrote:
> The Intel Restricted Access Region Handler provides a buffer allocation
> mechanism to RAR users.  Since the intended usage model is to lock out
> CPU access to RAR (the CPU will not be able to access RAR memory), this
> driver does not access RAR memory, and merely keeps track of what areas
> of RAR memory are in use.  It has it's own simple allocator that does
> not rely on existing kernel allocators (SLAB, etc) since those
> allocators are too tightly coupled with the paging mechanism, which isn't
> needed for the intended RAR use cases.
> 
> An mmap() implementation is provided for debugging purposes to simplify
> RAR memory access from the user space.  However, it will effectively be
> a no-op when RAR access control is enabled since the CPU will not be
> able to access RAR.
> 
> This driver should not be confused with the rar_register driver.  That
> driver exposes an interface to access RAR registers on the Moorestown
> platform.  The RAR handler driver relies on the rar_register driver for
> low level RAR register reads and writes.

Can you also send me a patch, that adds a TODO file to the directory of
this driver, that explains what you think needs to be done in order to
get this code merged into the main portion of the kernel tree, and
include your email address in it so that people who wish to send
patches, know who to copy on them?

See the other drivers/staging/*/TODO files for an example of what is
expected here.

thanks,

greg k-h
