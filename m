Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXCYTVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXCYTVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCYTVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:21:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34249 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbXCYTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:21:24 -0400
Date: Sun, 25 Mar 2007 21:21:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, "Kevin P. Fleming" <lkml@kpfleming.us>,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0 (not I/O)' on NVidia MCP51
Message-ID: <20070325192127.GR16477@stusta.de>
References: <460693EB.9080203@kpfleming.us> <20070325161144.GA12155@kroah.com> <20070325210846.05d3f2c8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070325210846.05d3f2c8@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 09:08:46PM +0100, Alan Cox wrote:
> > Jan, any thoughts about this?
> > Should this be backed out of the -stable releases?
> 
> All the code does if it prints that message.. is print that message.
>...

It also adds PCI_BASE_ADDRESS_SPACE_IO to the flags which it didn't 
without the patch.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

