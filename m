Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZCPAks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZCPAks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZCPAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:40:39 -0400
Received: from kroah.org ([198.145.64.141]:37618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752143AbZCPAki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:40:38 -0400
Date: Sun, 15 Mar 2009 17:39:32 -0700
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: more than 50 percent of dmesg belongs only to PCI and USB
Message-ID: <20090316003932.GB15098@kroah.com>
References: <1237016485.2935.12.camel@ht.satnam> <1237159729.8619.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237159729.8619.7.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:28:49AM +1100, Michael Ellerman wrote:
> On Sat, 2009-03-14 at 13:11 +0530, Jaswinder Singh Rajput wrote:
> > Can we make dmesg little bit better and remove some noise and put these
> > debug messages on /sys/kernel/debug/ :
> 
> I think they should just be KERN_DEBUG, that way they won't be displayed
> to most users, except people who want to see them.
> 
> The problem is it's easier to write:
> 
>   dev_info(&dev->dev, "transparent bridge\n");
> 
> than:
> 
>   dev_printk(KERN_DEBUG, &dev->dev, "transparent bridge\n");
> 
> and, dev_dbg() does not do what you want in this case.

Why not?  It prints it out if you enable the config option at run-time,
which is what you want.

thanks,

greg k-h
