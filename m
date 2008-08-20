Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYHTV5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYHTV5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYHTV4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:56:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYHTV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:56:54 -0400
Date: Wed, 20 Aug 2008 14:54:19 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Duncan Sands <duncan.sands@free.fr>,
       linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for August 20
Message-ID: <20080820215419.GA21339@kroah.com>
References: <20080820190649.a63e3e00.sfr@canb.auug.org.au> <20080820143656.88a03e1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820143656.88a03e1f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 02:36:56PM -0700, Andrew Morton wrote:
> On Wed, 20 Aug 2008 19:06:49 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> drivers/usb/atm/usbatm.c: In function 'usbatm_extract_one_cell':
> drivers/usb/atm/usbatm.c:347: error: implicit declaration of function 'warn'
> 
> due to
> 
> #define UDSL_ASSERT(x)  do { if (!(x)) warn("failed assertion '%s' at line %d", __stringify(x), __LINE__); } while(0)
> 
> which was quite clever really - neither drivers/usb/atm/usbatm.c nor
> drivers/usb/atm/usbatm.h was changed.
> 
> config: http://userweb.kernel.org/~akpm/config-akpm2.txt  (it's x86_64)

This was already fixed up, it was getting warn() from usb.h, which I'm
getting rid of.  dev_warn() should be used instead.

thanks,

greg k-h
