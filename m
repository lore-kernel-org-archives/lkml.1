Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXCFTGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXCFTGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXCFTGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:06:09 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:54633 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbXCFTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:06:08 -0500
Date: Tue, 06 Mar 2007 14:06:00 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4 +
 USB HD
In-reply-to: <Pine.LNX.4.44L0.0703061328570.24545-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070306190552.GA21166@pool-71-123-121-36.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <20070306154854.GD9198@pool-71-123-121-36.spfdma.east.verizon.net>
 <Pine.LNX.4.44L0.0703061328570.24545-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 01:34:41PM -0500, Alan Stern wrote:
> The stack trace didn't include the khubd process at all.  Probably that 
> means it had already died.

No, it's still there. I ran 'echo t >/proc/sysrq-trigger' again, and
khubd did not show up in dmesg:

-bash-2.05b# echo t >/proc/sysrq-trigger
-bash-2.05b# dmesg | grep khub
-bash-2.05b# dmesg | grep SysRq
SysRq : Show State
SysRq : Show State
-bash-2.05b# ps ax | grep khubd
  163 ?        R<   633:41 [khubd]
-bash-2.05b# echo p >/proc/sysrq-trigger
-bash-2.05b# dmesg | tail -2
 =======================
SysRq : Show Regs
-bash-2.05b#

So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
me anything at all. What else can I try?

-Eric

