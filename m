Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYEPWBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYEPWBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbYEPWB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:01:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55386 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbYEPWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:01:24 -0400
Date: Fri, 16 May 2008 15:00:40 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Andrew Bird <ajb@spheresystems.co.uk>
Subject: Re: 2.6.26-rc2-mm1: high speed something
Message-ID: <20080516220040.GA16909@kroah.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <20080516221749.GA3808@martell.zuzino.mipt.ru> <20080516143108.7b3b5d25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516143108.7b3b5d25.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 02:31:08PM -0700, Andrew Morton wrote:
> On Sat, 17 May 2008 02:17:49 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > >  linux-next.patch
> > 
> > That's terse. ;-)
> 
> well, it's a git tree, and all that this implies.  The git URL is
> right at the top of linux-next.patch.
> 
> > Who is responsible for something called "Option High Speed Mobile
> > Devices"?
> 
> The full changelog is contained in linux-next.patch.  Searching it for
> "Option" quickly leads to
> 
> commit a50a26ba350a5f32ec6481c85b938fc7fb476671
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Mon Apr 14 11:41:16 2008 -0700
> 
>     USB: add option hso driver
>     
>     This driver is for a number of different Option devices.  Originally
>     written by Option and Andrew Bird, but cleaned up massivly for
>     acceptance into mainline by me (Greg).
>     
>     TODO:
>     	- remove proc files and move to debugfs
>     	- review network interfaces
>     	- add better changelog information
>     	- Use netif_msg_ for the message level rather than module parameter
>     	- net_device_stats are now available in dev->stats
>     
>     Many thanks to the following for their help in cleaning up the driver by
>     providing feedback and patches to it:
>     	- Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>     	- Oliver Neukum <oliver@neukum.org>
>     	- Alan Cox <alan@lxorguk.ukuu.org.uk>
>     
>     
>     Cc: Andrew Bird <ajb@spheresystems.co.uk>
>     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Cc: Filip Aben <f.aben@option.com>
>     Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>     Cc: Oliver Neukum <oliver@neukum.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> > It's using create_proc_read_entry() interface, so should be switched
> > to seq_files before merging.

The whole proc interface is gone, so no need for that.

> > And "procfs" module parameter is plain stupid, sorry.

That parameter is gone, see the patches posted to lkml for an updated
version.

thanks,

greg "i'm stupid" k-h
