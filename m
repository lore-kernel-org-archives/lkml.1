Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbYF3TDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbYF3TDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYF3TDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:03:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbYF3TDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:03:16 -0400
Date: Mon, 30 Jun 2008 12:01:25 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 30 (USB: cdc-acm)
Message-ID: <20080630190125.GA3553@kroah.com>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <20080630114332.b797e5e4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630114332.b797e5e4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 11:43:32AM -0700, Randy Dunlap wrote:
> cdc-acm fails to build when CONFIG_PM=n:
> 
> linux-next-20080630/drivers/usb/class/cdc-acm.c: In function 'acm_suspend':
> linux-next-20080630/drivers/usb/class/cdc-acm.c:1263: error: 'struct usb_device' has no member named 'auto_pm'
> make[4]: *** [drivers/usb/class/cdc-acm.o] Error 1

Yeah, known issue due to the pm and usb trees conflicting here.  It will
be fixed up at the merge time with Linus.

Or so Alan promises :)

thanks,

greg k-h
