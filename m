Return-Path: <linux-kernel-owner+w=401wt.eu-S1161673AbXEAKQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161673AbXEAKQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161668AbXEAKQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:16:37 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42064 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161673AbXEAKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:16:35 -0400
Date: Tue, 1 May 2007 12:12:36 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
In-Reply-To: <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 05:16, Robert P. J. Day wrote:
>
>on the other hand, the features removal file contains the following:
>
>...
>What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
>When:   November 2005
>...
>
>in other words, the PCMCIA ioctl feature *has* been listed as obsolete
>for quite some time, and is already a *year and a half* overdue for
>removal.
>
>in short, it's annoying to take the position that stuff can't be
>deleted without warning, then turn around and be reluctant to remove
>stuff for which *more than ample warning* has already been given.
>doing that just makes a joke of the features removal file, and makes
>you wonder what its purpose is in the first place.
>
>a little consistency would be nice here, don't you think?

I think this could raise their attention...

init/Makefile
obj-y += obsolete.o

init/obsolete.c:
static __init int obsolete_init(void)
{
	printk("\e[1;31m""

The following stuff is gonna get removed \e[5;37m SOON: \e[0m
	- cardmgr
	- foobar
	- bweebol

");
	schedule_timeout(3 * HZ);
	return;
}

static __exit void obsolete_exit(void) {}



Jan
-- 
