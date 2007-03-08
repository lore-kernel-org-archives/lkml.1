Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXCHRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXCHRLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXCHRLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:11:48 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:38862 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXCHRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:11:47 -0500
From: Mws <mws@twisted-brains.org>
To: linux-kernel@vger.kernel.org
Subject: Re: irq nobody cared issue on 2.6.2x
Date: Thu, 8 Mar 2007 18:11:31 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: <200703072048.49637.mws@twisted-brains.org> <Pine.LNX.4.64.0703071204290.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071204290.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081811.32190.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007, Linus Torvalds wrote:
> 
> On Wed, 7 Mar 2007, Mws wrote:
> >
> > if you would be so kind to provide me some infos,
> > 
> > how i would be able to track the problem down _and_ maybe how to fix it.
> 
> The first step is to figure out as exactly as possible _when_ it started 
> happening.
> 
> > please find two snippets of dmesg after booting 2.6.21-rc3-git 
> > (2.6.20-1 has got the same results) 
> 
> So is 2.6.19 good? 2.6.20-rc1? -rc2?

went down to 2.6.17 - earlier is lacking due to correctly booting my machine.

> If you're a git user (or even just marginally interested in learning), the 
> best thing to do is to find some good kernel (the more recent, the better, 
> but the keyword is *some* kernel that works well), and a bad kernel (the 
> older the better, just to avoid unnecessary work, but again, you can just 
> take the most recent too), and then just use "git bisect".
> 
> If you bisect it down to one particular commit, that will help us a lot, 
> but even if you only bisect it down by booting a handful of kernels (say, 
> 5-6), it will already have cut things down a lot, and probably more easily 
> and efficiently than if you just downloaded daily snapshots and tried to 
> narrow it down that way.
> 
> 		Linus
i started to bring in a load of printk's into v4l dvb repository to find out what exactly 
is causing the interrupt to appear and why it is not handled.

the bug is reproducible by insmod/rmmod dvb_ttpci over and over.
yesterday late night i tried a bit too much and my machine freezed as a whole.

even kernel sysrq didn't work anymore.

i found some point, that after fireware load the interrupt is fired again.

will check if there is a solution to create a workaround and try to fix it afterwards.

it does NOT appear on a different computer same card. i think it is a problem
in combination chipset - card - bios.... dunno by now, but will find out.

thanks for your information, linus.

marcel
