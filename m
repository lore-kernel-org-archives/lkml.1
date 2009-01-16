Return-Path: <linux-kernel-owner+w=401wt.eu-S937754AbZAPV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937754AbZAPV1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764465AbZAPV1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:27:06 -0500
Received: from thor.auto.tuwien.ac.at ([128.130.60.15]:42913 "EHLO
	thor.auto.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763868AbZAPV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:27:05 -0500
Date: Fri, 16 Jan 2009 22:27:03 +0100
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile error in drivers/video/backlight/mbp_nvidia_bl.c - v2.6.28
Message-ID: <20090116212703.GA11952@auto.tuwien.ac.at>
References: <20090116080503.GA11855@auto.tuwien.ac.at> <1232129665.25018.8490.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232129665.25018.8490.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mkoegler@auto.tuwien.ac.at (Martin Koegler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 06:14:25PM +0000, David Woodhouse wrote:
> On Fri, 2009-01-16 at 09:05 +0100, Martin Koegler wrote:
> > 
> >   CC [M]  drivers/video/backlight/mbp_nvidia_bl.o
> > drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of
> > `__mod_dmi_device_table' isn't known
> 
> Hm, didn't we already have a patch to fix this? Is it fixed in
> 2.6.29-rc1, or did we drop the patch?

The bug is still present in:
commit 7cb36b6ccdca03bd87e8faca7fd920643dd1aec7
Merge: a9f8d25... 6272d68...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jan 15 16:55:00 2009 -0800

    Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip

All gcc 3.x on my system fail:
gcc-3.2 (GCC) 3.2.3 (Debian)
gcc-3.3 (GCC) 3.3.6 (Debian 1:3.3.6-15)
gcc-3.4 (GCC) 3.4.6 (Debian 3.4.6-5)

mfg Martin Kögler

