Return-Path: <linux-kernel-owner+w=401wt.eu-S936150AbZLQPKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936150AbZLQPKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935035AbZLQPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:10:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935020AbZLQPJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:09:59 -0500
Date: Thu, 17 Dec 2009 07:09:33 -0800
From: Greg KH <gregkh@suse.de>
To: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [50/90] e100: Use pci pool to work around GFP_ATOMIC order 5
 memory allocation failure
Message-ID: <20091217150933.GA2829@suse.de>
References: <20091217011604.483828174@mini.kroah.org>
 <200912171703.02902.roger.oksanen@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912171703.02902.roger.oksanen@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 05:03:02PM +0200, Roger Oksanen wrote:
> On Thursday 17 December 2009 03:15:01 Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> This commit has a problem, found in 
> http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/03887.html
> and while a fix is available at
> http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01012.html
> it should probably be merged into this patch when pushing it to 31.x?
> Obviously the fix should first be reviewed and pushed to Linus' tree...

Thanks for letting me know.  I'll drop this patch for now, until the fix
goes into Linus's tree, and then put both of them back in for a future
stable release.

Sound good?

thanks,

greg k-h
