Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXCGQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXCGQDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXCGQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:03:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53894 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932403AbXCGQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:03:24 -0500
Date: Wed, 7 Mar 2007 11:03:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ebuddington@wesleyan.edu
cc: Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <20070306190552.GA21166@pool-71-123-121-36.spfdma.east.verizon.net>
Message-ID: <Pine.LNX.4.44L0.0703071058480.6624-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Eric Buddington wrote:

> On Tue, Mar 06, 2007 at 01:34:41PM -0500, Alan Stern wrote:
> > The stack trace didn't include the khubd process at all.  Probably that 
> > means it had already died.
> 
> No, it's still there. I ran 'echo t >/proc/sysrq-trigger' again, and
> khubd did not show up in dmesg:
> 
> -bash-2.05b# echo t >/proc/sysrq-trigger
> -bash-2.05b# dmesg | grep khub
> -bash-2.05b# dmesg | grep SysRq
> SysRq : Show State
> SysRq : Show State
> -bash-2.05b# ps ax | grep khubd
>   163 ?        R<   633:41 [khubd]
> -bash-2.05b# echo p >/proc/sysrq-trigger
> -bash-2.05b# dmesg | tail -2
>  =======================
> SysRq : Show Regs
> -bash-2.05b#
> 
> So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
> me anything at all. What else can I try?

I'm baffled.  khubd should have shown up as the process with ID 163.  Is 
that process listed under a different name?

Alan Stern

