Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZEFGmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZEFGmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZEFGm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:42:29 -0400
Received: from kroah.org ([198.145.64.141]:46911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZEFGm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:42:28 -0400
Date: Tue, 5 May 2009 22:21:20 -0700
From: Greg KH <greg@kroah.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: eric.valette@free.fr, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: DMA debug trace pointing to rtl8187
Message-ID: <20090506052120.GA6239@kroah.com>
References: <49FDB9F8.3080400@free.fr> <20090506133131F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506133131F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:30:47PM +0900, FUJITA Tomonori wrote:
> CC'ed linux-usb,
> 
> The ehci_hcd driver uses buffers on the stack for DMA?

No, it should not.

But USB drivers are known to do this incorrectly.  Those USB drivers
should be fixed.

> On Sun, 03 May 2009 17:36:24 +0200
> Eric Valette <eric.valette@free.fr> wrote:
> 
> > ------------[ cut here ]------------
> > 
> > WARNING: at /usr/src/linux-2.6.22.9/lib/dma-debug.c:609
> 
> Hmm, the kernel version is wired. lib/dma-debug.c was added in
> 2.6.30-rc.

Very odd.  What specific kernel version caused this warning?

thanks,

greg k-h
