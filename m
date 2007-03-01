Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbXCANjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbXCANjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXCANjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:39:31 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:55306 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXCANja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:39:30 -0500
Date: Thu, 01 Mar 2007 08:39:07 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: Re: USB misbehavior causes system hang
In-reply-to: <20070227134940.63736039.zaitcev@redhat.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070301133857.GA4068@pool-71-161-135-187.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
 <20070227134940.63736039.zaitcev@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:49:40PM -0800, Pete Zaitcev wrote:
> However, the main issue here is the OOM with all the dirty data.
> We saw that before. For some weird reason, ext3 is especially good
> at producing the immense amounts of write-out. Are you on ext3 or
> VFAT on that drive?

Reiser4.

> Please try to find the CPU traces by hitting SysRq-w, SysRq-p. CPU
> is looping under a lock somewhere and eventually it cases the watchdog
> to trigger. It may be a USB issue, maybe a VM issue. I can't tell
> until we get stack traces.

I can log the dmesg's via netconsole, but I'm often not at the
computer to use SysRq. I've just discovered /proc/sysrq-trigger, which
I can maybe use from a script that watches dmesg. I'll report back if
I can catch the dumps.

-Eric



