Return-Path: <linux-kernel-owner+w=401wt.eu-S965340AbZLHBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340AbZLHBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbZLHBFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:05:24 -0500
Received: from kroah.org ([198.145.64.141]:45531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161AbZLHBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:05:22 -0500
Date: Mon, 7 Dec 2009 16:40:35 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-next@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: usb tree build warning
Message-ID: <20091208004035.GA18860@kroah.com>
References: <20091130170128.db346120.sfr@canb.auug.org.au>
 <Pine.LNX.4.44L0.0912011122060.2983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912011122060.2983-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 11:23:02AM -0500, Alan Stern wrote:
> On Mon, 30 Nov 2009, Stephen Rothwell wrote:
> 
> > Hi Greg,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> > 
> > drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_suspend':
> > drivers/net/wimax/i2400m/usb.c:595: warning: unused variable 'usb_dev'
> > 
> > Introduced by commit a85c653a3945350875611d3cb071a0143cfeb2d2 ("USB:
> > remove the auto_pm flag") which removed the last usage in this function.
> 
> Greg, can you fix this?  Simply modify the patch to eliminate the 
> unused local variable and the enclosing #ifdef.

Now fixed up.

thanks,

greg k-h
