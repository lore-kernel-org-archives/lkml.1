Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXFFJWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXFFJWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXFFJWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:22:23 -0400
Received: from mail2.zrz.TU-Berlin.DE ([130.149.4.14]:38813 "EHLO
	mail2.zrz.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFFJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:22:22 -0400
X-Greylist: delayed 2186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 05:22:22 EDT
From: Robert Gerlach <khnz@khnz.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] tablet buttons driver for fujitsu siemens laptops
Date: Wed, 6 Jun 2007 10:45:42 +0200
User-Agent: KMail/1.9.6
References: <200706020259.34033.khnz@gmx.de> <20070601183054.44c09935@freepuppy>
In-Reply-To: <20070601183054.44c09935@freepuppy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061045.42915.khnz@khnz.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2007 03:30:54 Stephen Hemminger wrote:
> On Sat, 2 Jun 2007 02:59:33 +0200
> > #ifdef DEBUG
> > #  define debug(m, a...)	printk( KERN_DEBUG   MODULENAME ": " m "\n",
> > ##a) #else
> > #  define debug(m, a...)	do {} while(0)
> > #endif
> >
> > #define info(m, a...)	printk( KERN_INFO    MODULENAME ": " m "\n", ##a)
> > #define warn(m, a...)	printk( KERN_WARNING MODULENAME ": " m "\n", ##a)
> > #define error(m, a...)	printk( KERN_ERR     MODULENAME ": " m "\n", ##a)
>
> Please don't reinvent
> 	pr_debug
> 	pr_info

Changed.

> 	pr_warn,...

There is no pr_warn. Is it ok to define it like pr_err in spider_net.c or is 
there a better way?


Many thanks,
Robert

