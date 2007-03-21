Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbXCUAQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbXCUAQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 20:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXCUAQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 20:16:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:34593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbXCUAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 20:16:39 -0400
Date: Tue, 20 Mar 2007 17:14:26 -0700
From: Greg KH <greg@kroah.com>
To: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] fbdev sysfs imrovements
Message-ID: <20070321001426.GA29665@kroah.com>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 02:25:49PM +0000, James Simmons wrote:
> 
> This patch does several things to allow the underlying hardware to be 
> shared amount many devices. The most important thing is the use of
> the created device via device_create instead of the hardware device. No 
> longer should fbdev drivers use the xxx_set_drvdata with the parent
> bus device. The second change is having a bus independent power management
> for the framebuffer driver. The final change is using the release method 
> to cleanup the device. The reason again is to make the fbdev driver 
> independent of the bus parent device. Feedback is welcomed.

Looks good to me.

thanks,

greg k-h
