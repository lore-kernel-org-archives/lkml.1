Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXKZIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXKZIrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXKZIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:47:13 -0500
Received: from aun.it.uu.se ([130.238.12.36]:41656 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbXKZIrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:47:12 -0500
Date: Mon, 26 Nov 2007 09:47:06 +0100 (MET)
Message-Id: <200711260847.lAQ8l6rE027837@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: joshin@hotmail.com, linux-kernel@vger.kernel.org, mikpe@it.uu.se
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 22:28:03 -0700, Josh Goldsmith wrote:
> Is your 486 running a IDE disk on a normal interface or via USB?  I wonder 
> if the NSLU2 only having I/O via USB might be significant.

My 486 has neither PCI nor USB, the disk is attached to a
plain ancient IDE port.

>  Also, this is a 
> 2.6 kernel and I've seen spurious reports across the internet about similar 
> oom-killer problems since about 2.6.7.

If it is, I don't think it's ARM-specific. The last two years
I've done a lot of work with 2.6 kernels on a DS101 ARM box.
It's similar to the NSLU2 except it has 64MB of RAM and a built-in
PCI PATA controller. I've stressed it quite a bit, but never
seen the OOM killer trigger on it.

So you using USB storage might be relevant.
