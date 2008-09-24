Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYIXSRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYIXSRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYIXSRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:17:08 -0400
Received: from [198.145.64.141] ([198.145.64.141]:49089 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbYIXSRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:17:06 -0400
Date: Wed, 24 Sep 2008 11:14:03 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
Message-ID: <20080924181403.GA6336@kroah.com>
References: <48DA64FC.4020706@gmail.com> <Pine.LNX.4.44L0.0809241229070.5963-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0809241229070.5963-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:38:45PM -0400, Alan Stern wrote:
> On Wed, 24 Sep 2008, Jiri Slaby wrote:
> 
> > > In fact neither of those logs includes USB debugging messages.  Maybe
> > > you omitted a mkinitrd step.
> > 
> > I don't think so. I don't use neither vanilla nor initrd so this must be the
> > kernel. Anyway I recompiled with .config linked in and did
> > # dmesg >dmesg_config.hcd
> > # zcat /proc/config.gz >>dmesg_config.hcd
> > in the built kernel. The file is here:
> > http://decibel.fi.muni.cz/~xslaby/dmesg_config.hcd
> 
> Still no debugging messages.  It's because you have 
> CONFIG_DYNAMIC_PRINTK_DEBUG enabled.

If you have that enabled, you can turn on debugging "on the fly" by
writing to the debugfs file as described in the documentation for that
option.

thanks,

greg k-h
