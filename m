Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYF3OLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYF3OLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYF3OLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:11:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:59500 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYF3OLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:11:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: usb_get_status(): what a weird implementation !
Date: Mon, 30 Jun 2008 16:11:41 +0200
User-Agent: KMail/1.9.9
Cc: "David Brownell" <david-b@pacbell.net>, linux-usb@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200806261011.00287.oliver@neukum.org> <200806301551.42252.oliver@neukum.org> <38b2ab8a0806300703j7c0f0567w4cf1730fbe375c00@mail.gmail.com>
In-Reply-To: <38b2ab8a0806300703j7c0f0567w4cf1730fbe375c00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301611.42464.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 Juni 2008 16:03:52 schrieb Francis Moreau:
> On Mon, Jun 30, 2008 at 3:51 PM, Oliver Neukum <oliver@neukum.org> wrote:
> >
> > If your buffer is smaller than CACHE_LINE_SIZE it should work.
> > However, this needs input from people who understand DMA in and out.
> 
> yeah, that's the reason why it's a hack.
> 
> Maybe adding a new helper in  the dma API would be better...
> 
> > But how large is 2 * CACHE_LINE_SIZE compared to the kernel stack?
> 
> CACHE_LINE_SIZE = 32 bytes is common for embedded systems I guess.
> For big system, I dunno.
> 
> Kernel stack size is usually  4KiB.
> 

Well, we have:
asm-mips/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
That's 256 bytes, that is 1/16 of the stack.

	Regards
		Oliver

