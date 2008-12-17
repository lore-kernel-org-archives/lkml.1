Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759071AbYLQGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbYLQGnX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 01:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYLQGmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 01:42:53 -0500
Received: from kroah.org ([198.145.64.141]:51771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753596AbYLQGmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 01:42:52 -0500
Date: Tue, 16 Dec 2008 22:36:55 -0800
From: Greg KH <greg@kroah.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: driver probe error reporting
Message-ID: <20081217063655.GA12933@kroah.com>
References: <20081215231502.GC12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215231502.GC12431@fluff.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 11:15:02PM +0000, Ben Dooks wrote:
> This runs on from the discussion in [1] on how drivers (especially
> one using a variant of the device driver framework) report errors
> on probe. There are two main classes of errors, the type which happen
> at probe time (device not responding, not enough memory, etc) and
> errors that are due to configuration such as missing device configuration
> data.
> 
> It has been suggested that using dev_err() to report any configuration
> data error is a bloat of code as a properly debugged kernel should never
> find itself in this state.
> 
> Unfortunatley the only diagnostic dev_xxx() macro is dev_dbg() which is
> only available if the the driver code itself defines DEBUG. I would think
> it would be better to have a macro that can be turned on/off by a kernel
> configuration for when debugging which turns on the messages that are
> important to developers creating new machine/arch support but disabled
> for shipping kernels.

Not anymore, dev_dbg() can be dynamically switched on and off at runtime
in 2.6.28.

> Basically, what are people's thoughts on a "Verbose probe error"
> configuration option in the "Kernel hacking" submenu with its own
> dev_probe_err() or similar macro?

It is not needed, see the above :)

thanks,

greg k-h
