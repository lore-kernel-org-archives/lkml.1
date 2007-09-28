Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXI1RqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXI1RqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXI1RqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:46:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbXI1RqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:46:12 -0400
Message-ID: <46FD3DE1.9000807@redhat.com>
Date: Fri, 28 Sep 2007 13:46:09 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Sergey Popov <faijeya@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: General slowness with using 64Gb HIGHMEM option on 32-bit kernel
References: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
In-Reply-To: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2007 01:15 PM, Sergey Popov wrote:
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

Boot with option "mem=3900M".
