Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXCHPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXCHPK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXCHPK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:10:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53545 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752076AbXCHPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:10:58 -0500
Date: Thu, 8 Mar 2007 10:10:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: ebuddington@wesleyan.edu, Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <20070307150227.e5395d6c.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0703081008340.4086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Pete Zaitcev wrote:

> On Wed, 7 Mar 2007 17:18:29 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > I've never heard of a process failing to show up in a SysRq-t listing.  It 
> > suggests something is wrong with the process management in the kernel you 
> > were using.  That leads me to think a non -mm kernel might give more 
> > informative results.
> 
> I think, if a process is looping, it's not shown in SysRq-t. So maybe
> khubd is on a CPU.

You mean, if it is currently running?  I don't believe that.  A simple 
test comparison shows every process listed in "ps -A" also listed in 
SysRq-t.

> In RHEL we have a patch for SysRq-w, which showed all CPU states by
> the way of a special IPI (unless looping with closed interrups, of course).
> But this capability seems a bit degraded in stock SysRq-w. It might not
> catch this (does not seem for me in 2.6.20).
> 
> Another possibility is, something killed khubd. It's only a process
> after all. Remember how we had grief with it being killed by "telinit 1".

If it was killed then it wouldn't show up in "ps" or as a directory under 
/proc.

Alan Stern

