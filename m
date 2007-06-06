Return-Path: <linux-kernel-owner+w=401wt.eu-S934708AbXFFQQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708AbXFFQQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXFFQQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:16:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbXFFQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:16:20 -0400
Date: Wed, 6 Jun 2007 09:03:59 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Robert Gerlach <khnz@khnz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] tablet buttons driver for fujitsu siemens laptops
Message-ID: <20070606090359.5550a813@freepuppy>
In-Reply-To: <200706061045.42915.khnz@khnz.de>
References: <200706020259.34033.khnz@gmx.de>
	<20070601183054.44c09935@freepuppy>
	<200706061045.42915.khnz@khnz.de>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
X-Face: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 10:45:42 +0200
Robert Gerlach <khnz@khnz.de> wrote:

> On Saturday 02 June 2007 03:30:54 Stephen Hemminger wrote:
> > On Sat, 2 Jun 2007 02:59:33 +0200
> > > #ifdef DEBUG
> > > #  define debug(m, a...)	printk( KERN_DEBUG   MODULENAME ": " m "\n",
> > > ##a) #else
> > > #  define debug(m, a...)	do {} while(0)
> > > #endif
> > >
> > > #define info(m, a...)	printk( KERN_INFO    MODULENAME ": " m "\n", ##a)
> > > #define warn(m, a...)	printk( KERN_WARNING MODULENAME ": " m "\n", ##a)
> > > #define error(m, a...)	printk( KERN_ERR     MODULENAME ": " m "\n", ##a)
> >
> > Please don't reinvent
> > 	pr_debug
> > 	pr_info
> 
> Changed.
> 
> > 	pr_warn,...
> 
> There is no pr_warn. Is it ok to define it like pr_err in spider_net.c or is 
> there a better way?
> 

The best would be to use the following if you have a device
	dev_err, dev_info, dev_warn, dev_notice

Also, you need to format this a proper patch with config, makefile, etc.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
