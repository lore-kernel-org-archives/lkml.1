Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXGCGAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXGCGAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbXGCF74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:59:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58540 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXGCF74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:59:56 -0400
Date: Mon, 2 Jul 2007 22:59:15 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-usb-devel@lists.sourceforge.net, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
Message-ID: <20070703055915.GA19086@kroah.com>
References: <200706291326.43563.yinghai.lu@sun.com> <200707021537.13840.yinghai.lu@sun.com> <20070703051336.GF18420@kroah.com> <86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 10:17:56PM -0700, Yinghai Lu wrote:
>  On 7/2/07, Greg KH <greg@kroah.com> wrote:
> > On Mon, Jul 02, 2007 at 03:37:13PM -0700, Yinghai Lu wrote:
> > > [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
> >
> > Um, your subject doesn't match the patch below.  You might want to
> > verify it again...
> >
> 
>  it should be
> 
>  [PATCH 4/4] usb: add usb_alloc_urb_node to use use kmalloc_node

On the linux-usb-devel list we are discussing how usb_alloc_urb is being
reworked to look totally different, so this change will conflict with
that.

Also, any real numbers to justify these changes?  I know how slow USB
really is and I'd be supprised if this matters.

thanks,

greg k-h
