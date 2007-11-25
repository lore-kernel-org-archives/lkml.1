Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbXKYW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbXKYW4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXKYWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:55:55 -0500
Received: from aun.it.uu.se ([130.238.12.36]:37350 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbXKYWzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:55:54 -0500
Date: Sun, 25 Nov 2007 23:55:48 +0100 (MET)
Message-Id: <200711252255.lAPMtms7024172@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: joshin@hotmail.com, linux-kernel@vger.kernel.org
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 15:02:15 -0700, Josh Goldsmith wrote:
>   I have a Linksys NSLU2 running 2.6.21 (I can replicate the problem on 
> 2.6.23 but it isn't fully supported on SlugOS).  It is a armv5teb device 
> with 32MB of RAM, 400+ MB swap on its 160GB USB2 root disk.  The machine is 
> used as a fileserver and to build packages for other ARM devices.  It may be 
> underpowered by today's standard but is a whole lot faster than my first 
> Linux system (386sx20 with 4MB RAM) but the whole system with disk uses <8 
> watts and is silent.
> 
>   The problem comes when I try to untar a large file (in this case 
> linux-2.6.23.tar.bz2).  Regardless if I kill off every other process, 
> eventually the oom-killer will appear and kill either the tar or the shell. 
> I've tried every tuning option I and my buddy Google could find including 
> (/proc/sys/vm/overcommit*) with no success.  I'm not worried about paging 
> impacting performance.
> 
>   I'd appreciate any help, pointers, or gentle taps with the cluebat.

I'm no VM tuning expert, but I have and still do heavy compile
jobs on similarly configured machines, with no OOM problems:

I regularly build 2.6 kernels and occasionally also gcc on a
100MHz 486 with 28MB of RAM and perhaps 500MB of swap. It runs
a standard but stripped down Fedora Core 4 user-space, with ext3
file systems and a kernel that doesn't include anything non-essential. 
The machine will swap madly, but the OOM killer never triggers.
(All system settings are FC4 defaults. I haven't touched them.)

In the past I did a fair amount of package rebuilds and test suite
runs on an NSLU2 myself, with a 2.4 Linksys/Openslug kernel, ext3,
and a 1GB or perhaps 2GB swap partition on a disk attached via a
USB2-to-PATA enclosure. Even when swapping heavily the OOM killer
wouldn't trigger.
