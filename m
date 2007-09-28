Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXI1Xke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXI1Xke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXI1Xk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:40:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:35305 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbXI1Xk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:40:27 -0400
Date: Fri, 28 Sep 2007 17:40:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: General slowness with using 64Gb HIGHMEM option on 32-bit kernel
In-reply-to: <fa.mssrRT/qBOVwvrr2k/d2or6ggOo@ifi.uio.no>
To: Sergey Popov <faijeya@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46FD90E7.6090009@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.mssrRT/qBOVwvrr2k/d2or6ggOo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Popov wrote:
> Short description: after recompiling 32-bit kernel with 64Gb highmem
> support and rebooting into it, OS started working very much slower
> then before.
> 
> Specifications: Intel Core 2 Duo E6600@2,4Ghz on Intel i965Q-based
> motherboard. 6Gb of DDR2 RAM, 2x1Gb+2x2Gb, dual-channel.
> Vector Linux 5.8 (Slackware Linux 11-based), 2.6.20.3 kernel.
> 
> Long description: after recompiling 32-bit 2.6.20.3 kernel with 64Gb
> highmem option and rebooting into it, booting process froze on udevd.
> After booting up from CD and disabling rc.udev, system started, but
> it's work after rc.M script sarted was 5-10 times slower then usual.
> top showed, that processes are taking much more CPU% time then usual.
> I tried downloading the newest stable kernel - 2.6.22.9 - hoping, that
> it would solve the problem. I downloaded it, booted from CD, and
> compiled it with 64Gb highmem support. I felt some speed improvement,
> but if on 2.6.20.3 machine performed like P166, now it is working like
> P2-350.
> I've found a similar problem, described on lkml -
> http://lkml.org/lkml/2007/5/30/5 . But, unfortunately, it is x86_64
> related and contains no clues for me.
> 
> Moving to 64-bit distro is rather unpleasant - as there is an option
> in 32-bit kernel, it should work ;) .
> 
> What tests should I run to help investigate this problem?

Make sure your BIOS is up to date. If so, post your dmesg output and the 
contents of /proc/mtrr. There are a number of Intel boards which 
have/had BIOS bugs where the BIOS didn't set up the MTRRs to mark all 
RAM as write-back. This results in the last bit of memory being 
uncacheable and causes a major performance drop.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

