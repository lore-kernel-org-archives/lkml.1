Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZHKACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZHKACX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZHKACV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 20:02:21 -0400
Received: from kroah.org ([198.145.64.141]:56593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZHKACU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 20:02:20 -0400
Date: Mon, 10 Aug 2009 17:00:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lothar Wassmann <LW@KARO-electronics.de>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: linux-next: usb tree build warnings
Message-ID: <20090811000019.GA13314@kroah.com>
References: <20090810193653.f228cf06.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810193653.f228cf06.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 07:36:53PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> In file included from drivers/usb/host/isp1362-hcd.c:100:
> drivers/usb/host/isp1362.h: In function 'ALIGNSTAT':
> drivers/usb/host/isp1362.h:583: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362.h: In function 'isp1362_write_fifo':
> drivers/usb/host/isp1362.h:773: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362.h: In function 'isp1362_read_buffer':
> drivers/usb/host/isp1362.h:965: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362.h: In function 'isp1362_write_buffer':
> drivers/usb/host/isp1362.h:985: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362-hcd.c: In function 'isp1362_irq':
> drivers/usb/host/isp1362-hcd.c:1079: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> drivers/usb/host/isp1362-hcd.c:1091: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> drivers/usb/host/isp1362-hcd.c: In function 'isp1362_mem_config':
> drivers/usb/host/isp1362-hcd.c:2283: warning: format '%3u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
> drivers/usb/host/isp1362-hcd.c:2286: warning: format '%3u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
> drivers/usb/host/isp1362-hcd.c: In function 'isp1362_remove':
> drivers/usb/host/isp1362-hcd.c:2676: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362-hcd.c:2680: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362-hcd.c: In function 'isp1362_probe':
> drivers/usb/host/isp1362-hcd.c:2809: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362-hcd.c:2812: warning: cast from pointer to integer of different size
> drivers/usb/host/isp1362-hcd.c:2818: warning: cast from pointer to integer of different size
> 
> Introduced by commit 994857f5ead1a4f1d9152c5bbd6e63c2ec2d2b55 ("USB: NXP
> ISP1362 USB host driver").

Ick, thanks, I'll look into this.

greg k-h
