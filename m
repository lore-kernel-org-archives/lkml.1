Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXEMRyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXEMRyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXEMRy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:54:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbXEMRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:54:28 -0400
Date: Sun, 13 May 2007 10:53:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Antonino Ingargiola <tritemio@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 May 2007, Antonino Ingargiola wrote:
> 
> On my desktop pc with Debian Etch and 2.6.22-rc1 the gnome panel
> applet "Sensors Applet" give an error message "No chip detected".
> Works fine on 2.6.21.1 (it show cpu temperature) with the same config
> (I've only only done  make oldconfig).

One thing to check is that "make oldconfig" can actually change the
configuration if things were moved behind a new top-level configuration 
parameter or such. I'm not saying that's the case here, but it's possible 
that things like the i2c changes might have made you inadvertedly changed 
some config option.

> Is this considered a regression or can be due to userland incompatibilities?

It's a regression, although I'd like to know more about your cases. It's 
just hard to tell what happened: was it a i2c/hwmon driver that got 
broken, or is it some sysfs file that got buggered, or what..

For example, "dmesg" output before and after (preferably as a diff between 
the two), and what modules you had loaded in the working/nonworking case.

			Linus
