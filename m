Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXCGUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXCGUri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992558AbXCGUri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:47:38 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:40063 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992554AbXCGUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:47:37 -0500
Date: Wed, 07 Mar 2007 15:47:32 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4 +
 USB HD
In-reply-to: <Pine.LNX.4.44L0.0703071513490.8656-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ebuddington@wesleyan.edu, Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070307204722.GA3605@pool-71-123-121-36.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <20070307163220.GC889@pool-71-123-121-36.spfdma.east.verizon.net>
 <Pine.LNX.4.44L0.0703071513490.8656-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 03:22:05PM -0500, Alan Stern wrote:
> On Wed, 7 Mar 2007, Eric Buddington,,, wrote:
> 
> > > > So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
> > > > me anything at all. What else can I try?
> 
> How about SysRq-r?

SysRq : Keyboard mode set to XLATE

> These problems start with some USB resets, right?  Did they occur with 
> earlier kernel versions, or is this new behavior?

Yes, the problem starts with USB resets (or USB errors that trigger a reset)

> How often does the problem occur?

Recently, the USB drive has choked up after several hours of moderate
use. However, before this instance, it would consistently hang up my
watchdog process and force a system reboot (no idea why; the watchdog
process didn't use this drive at all). This may have changed when I
upgraded from 2.6.20-rc6-mm3 to 2.6.20-mm2, but my sample size is to
small to be sure.

-Eric

