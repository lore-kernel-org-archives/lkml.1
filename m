Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbXJ2Tt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbXJ2Tt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbXJ2TsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:48:23 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35691 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbXJ2TsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:48:21 -0400
Date: Mon, 29 Oct 2007 15:48:20 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071029194820.GC27646@csclub.uwaterloo.ca>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028180707.GA6111@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 06:07:07PM +0000, Pavel Machek wrote:
> Hard stuff:
> 
> * network character device -- similar to nbd, but for char devices.
>   either figure out how to forward ioctls(), or implement
>   usb-over-network, or...
> 
> * openMosix -- they seem to have userspace solution, but not GPLed.
> 
> * compression for ext4. Its about time someone did it right. Special
>   bonus if you can do it in a way that it does not slow down. If cpu
>   is free, compress, if it is busy, just write it straight to disk.

So if I decide that the cpu is busy (because something is asking me to
write the cpu is clearly doing something and hence busy), then I can
skip compression and just write to disk.  So by that definition ext4
already does compression.  What a simple project. :)

Did you mean it ought to come back and do the compression later?

Is it possible that for some data compressing it and writing will take
less time than not compressing it and writing it to disk?

--
Len Sorensen
