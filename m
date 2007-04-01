Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXDAA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXDAA4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 20:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXDAA4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 20:56:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXDAA4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 20:56:38 -0400
Date: Sun, 1 Apr 2007 01:56:28 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fbdev sysfs imrovements
In-Reply-To: <20070326195807.184474d7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704010156001.5314@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
 <20070326195807.184474d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I can't seem to duplicate this error. Do you have any patches applied to 
the nvidia driver?

On Mon, 26 Mar 2007, Andrew Morton wrote:

> On Tue, 20 Mar 2007 14:25:49 +0000 (GMT) James Simmons <jsimmons@infradead.org> wrote:
> 
> > This patch does several things to allow the underlying hardware to be 
> > shared amount many devices. The most important thing is the use of
> > the created device via device_create instead of the hardware device. No 
> > longer should fbdev drivers use the xxx_set_drvdata with the parent
> > bus device. The second change is having a bus independent power management
> > for the framebuffer driver. The final change is using the release method 
> > to cleanup the device. The reason again is to make the fbdev driver 
> > independent of the bus parent device. Feedback is welcomed.
> 
> Causes an early crash on the powermac G5.
> 
> http://userweb.kernel.org/~akpm/s5000489.jpg (the oops is the usual powerpc
> mess)
> 
> config at http://userweb.kernel.org/~akpm/config-g5.txt
> 
