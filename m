Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXLGA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXLGA6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXLGA6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:58:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXLGA6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:58:09 -0500
Date: Thu, 6 Dec 2007 17:00:01 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
Message-ID: <20071207010001.GA23575@kroah.com>
References: <20071205064116.D849BDE10A@ozlabs.org> <1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com> <1196927934.7033.39.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196927934.7033.39.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 06:58:54PM +1100, Benjamin Herrenschmidt wrote:
> 
> On Wed, 2007-12-05 at 22:39 -0800, Greg KH wrote:
> > > that is  it can be either unsigned int, unsigned long or unsigned
> > long
> > > long... and we have no way to reliably printk that.
> > 
> > We do this already just fine.  Take a look in the kernel, I think we
> > just always cast it to long long to be uniform.
> 
> I wanted to avoid that for two reasons:
> 
>  - casts are fugly
>  - it adds support code to cast & handle 64 bits to 32 bits platforms
>    that wouldn't normally need it

But that is how we already handle this today, in numerous places in the
kernel for this very type.

So, you can disagree that this is what we need to do, and if so, feel
free to fix up a whole lot of files in the tree :)

thanks,

greg k-h
