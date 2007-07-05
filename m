Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbXGEOZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbXGEOZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbXGEOZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:25:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55230 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757684AbXGEOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:25:07 -0400
Date: Thu, 5 Jul 2007 10:25:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, <rjw@sisk.pl>, <mjg59@srcf.ucam.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <18060.15630.812698.367707@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707051023520.3728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Paul Mackerras wrote:

> Alan Stern writes:
> 
> > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > wanting to resume devices during a system suspend transition?  This is
> > exactly what happens when those threads aren't frozen.
> 
> So, I wonder why I don't see that error on my powerbook?

That's a good question.  Miklos, can you please reproduce the suspend 
error using a kernel built with CONFIG_USB_DEBUG turned on?

Alan Stern

