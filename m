Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXFBBnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXFBBnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXFBBnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:43:17 -0400
Received: from main.gmane.org ([80.91.229.2]:49482 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814AbXFBBnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:43:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC] tablet buttons driver for fujitsu siemens laptops
Date: Fri, 1 Jun 2007 18:30:54 -0700
Organization: Linux Foundation
Message-ID: <20070601183054.44c09935@freepuppy>
References: <200706020259.34033.khnz@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <200706020259.34033.khnz@gmx.de>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
X-Face: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 02:59:33 +0200
Robert Gerlach <khnz@gmx.de> wrote:

> Hi,
> 
> I have written a driver for the tablet buttons of (some?) Fujitsu Siemens 
> tablet notebook. Can someone please review this (I'm a newbie here).
> 
> Other questions, where should the modification button (fn) handled (kernel- or 
> userspace)? This button should work like stickykey's in gnome (for 
> one-finger-use). Currently, I have a small userspace daemon for this.
> 
> Some models doesn't have a brightness up and down, only a backlight on and off 
> button. What event should reported there.
> 
> Thanks,
> Robert
> 
> 
> #ifdef DEBUG
> #  define debug(m, a...)	printk( KERN_DEBUG   MODULENAME ": " m "\n", ##a)
> #else
> #  define debug(m, a...)	do {} while(0)
> #endif
> 
> #define info(m, a...)	printk( KERN_INFO    MODULENAME ": " m "\n", ##a)
> #define warn(m, a...)	printk( KERN_WARNING MODULENAME ": " m "\n", ##a)
> #define error(m, a...)	printk( KERN_ERR     MODULENAME ": " m "\n", ##a)
>
>

Please don't reinvent
	pr_debug
	pr_info
	pr_warn,...


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

