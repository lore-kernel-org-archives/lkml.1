Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbXENSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbXENSXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbXENSXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:23:33 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:1480 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756134AbXENSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:23:32 -0400
Date: Mon, 14 May 2007 20:24:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514202419.33a90f57@hyperion.delvare>
In-Reply-To: <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	<20070514081022.7fcee97f@hyperion.delvare>
	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	<20070514141437.631fcfd1@hyperion.delvare>
	<5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
	<20070514172138.1c870793@hyperion.delvare>
	<alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Mon, 14 May 2007 09:30:19 -0700 (PDT), Linus Torvalds wrote:
> On Mon, 14 May 2007, Jean Delvare wrote:
> > 
> > This is a side effect of an i2c-core cleanup. This is already fixed in
> > lm_sensors 2.10.3 (libsensors.so.3.1.3).
> 
> So apparently that fixed it, but in general we do not allow these kinds of 
> "need to have new xyz with new kernel".

Sure, we don't allow that. Except for xfsprogs in 2.6.1, procps in
2.6.4, oprofile in 2.6.13 and udev in 2.6.19, of course.

> Kernels are supposed to be backwards compatible. Jean, what was it that 
> changed, and why can't we just make them appear the same?
> 
> It may be that something like a sensors package isn't important enough to 
> worry about (the machine still *works*, and everything else won't notice), 
> but if it's a simple matter of adding some random file to /sysfs, we 
> should just do it.

We already have CONFIG_SYSFS_DEPRECATED for that.

-- 
Jean Delvare
