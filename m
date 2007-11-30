Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXK3J3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXK3J3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXK3J26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:28:58 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:30891 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXK3J24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:28:56 -0500
Date: Fri, 30 Nov 2007 12:28:43 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC - organize include/linux/kernel.h, add include/linux/logging.h
Message-ID: <20071130092842.GA6221@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> kernel.h has become a bit disorganized over a long time.
> Here's an attempt to clean it up a bit.
> 
> Something for everyone to like or dislike...

You duplicate ALIGN macros all over the place.

> Groups externs and functions by module/function
> Creates a "logging.h" for printk, KERN_<level>
> Changes some macros to statement expressions
> 	DIV_ROUND_UP, roundup and __ALIGN_MASK
> Removes the unused PTR_ALIGN

> This one used the ALIGN macro, but I'm not inclined to
> figure out what it actually does right now, so copy
> the old macro to this file and renames it.

Which is not acceptable. Ditto for DIV_ROUND_UP.

And you somehow decided that putting statements on one line is more
readable than on multiple lines -- typecheck and friends.

Overall impression -- moving code just because you can.

