Return-Path: <linux-kernel-owner+w=401wt.eu-S965488AbXBRAsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488AbXBRAsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXBRAsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:48:25 -0500
Received: from thunk.org ([69.25.196.29]:46288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965488AbXBRAsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:48:17 -0500
Date: Sat, 17 Feb 2007 18:07:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 15/44 take 2] [UBI] scanning unit header
Message-ID: <20070217230746.GD16522@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165540.5845.31238.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165540.5845.31238.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:55:40PM +0200, Artem Bityutskiy wrote:
> +/**
> + * ubi_scan_erase_peb - erase a physical eraseblock.
> + *
> + * @ubi: the UBI device description object
> + * @si: a pointer to the scanning information
> + * @pnum: physical eraseblock number to erase;
> + * @ec: erase counter value to write (%NAND_SCAN_UNKNOWN_EC if it is unknown)
> + *
> + * This function erases physical eraseblock 'pnum', and writes the erase
> + * counter header to it. This function should only be used on UBI device
> + * initialization stages, when the EBA unit had not been yet initialized. This
> + * function returns zero in case of success and a negative error code in case
> + * of failure.
> + */

This is a general comment that applies across your entire patchset.
It would be a lot easier to review the patchset if you put the Docbook
description of the function with the .c file instead of the .h file.
This will also make it much more likely that when you or other people
update the code function, that the documentation will get updated as
well.

I'd recommend doing this along with combining all of your *.h files
into a ubi_private.h and ubi.h file.

Regards,

							- Ted
