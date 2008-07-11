Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYGKTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYGKTXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbYGKTUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:20:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759432AbYGKTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:20:22 -0400
Date: Fri, 11 Jul 2008 12:19:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/17] Clear the WARN() namespace
Message-Id: <20080711121930.755736f7.akpm@linux-foundation.org>
In-Reply-To: <20080708093930.44ba9d08@infradead.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708093930.44ba9d08@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 09:39:30 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> We want to use WARN() as a variant of WARN_ON(), however a few drivers are
> using WARN() internally.  This patch renames these to WARNING() to avoid the
> namespace clash.  A few cases were defining but not using the thing, for those
> cases I just deleted the definition.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Greg KH <greg@kroah.com>
> Cc: Karsten Keil <kkeil@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/isdn/hisax/st5481.h       |    4 
>  drivers/isdn/hisax/st5481_b.c     |    4 
>  drivers/isdn/hisax/st5481_d.c     |    6 
>  drivers/isdn/hisax/st5481_usb.c   |   18 +-
>  drivers/usb/gadget/at91_udc.h     |    2 
>  drivers/usb/gadget/cdc2.c         |    2 
>  drivers/usb/gadget/ether.c        |    2 
>  drivers/usb/gadget/file_storage.c |   14 -
>  drivers/usb/gadget/fsl_usb2_udc.c |    2 
>  drivers/usb/gadget/fsl_usb2_udc.h |    2 
>  drivers/usb/gadget/gmidi.c        |    2 
>  drivers/usb/gadget/goku_udc.c     |    2 
>  drivers/usb/gadget/goku_udc.h     |    2 
>  drivers/usb/gadget/inode.c        |    2 
>  drivers/usb/gadget/net2280.c      |    2 
>  drivers/usb/gadget/net2280.h      |    2 
>  drivers/usb/gadget/omap_udc.c     |    6 
>  drivers/usb/gadget/omap_udc.h     |    2 
>  drivers/usb/gadget/printer.c      |    2 
>  drivers/usb/gadget/pxa25x_udc.c   |    6 
>  drivers/usb/gadget/pxa25x_udc.h   |    2 
>  drivers/usb/gadget/u_ether.c      |    3 
>  drivers/usb/host/isp116x-hcd.c    |    2 
>  drivers/usb/host/isp116x.h        |    2 
>  drivers/usb/host/sl811-hcd.c      |    2 
>  drivers/usb/host/sl811.h          |    2 
>  drivers/usb/misc/usbtest.c        |    4 
>  include/linux/usb/composite.h     |    2 

After fixing rejects, this appears to be identical to what I already had.


>  usr/share/quilt/refresh           |  304 --------------------------------------

Except for this curosity, which I rather hope wasn't supposed to be there.

