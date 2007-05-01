Return-Path: <linux-kernel-owner+w=401wt.eu-S1945963AbXEAUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963AbXEAUrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946009AbXEAUqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:46:55 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58209 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946004AbXEAUqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:46:53 -0400
Date: Tue, 1 May 2007 22:41:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
In-Reply-To: <20070501191056.GC19872@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.61.0705012239050.18504@yvahk01.tjqt.qr>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain>
 <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
 <20070501191056.GC19872@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 20:10, Russell King wrote:
>On Tue, May 01, 2007 at 12:12:36PM +0200, Jan Engelhardt wrote:
>> init/obsolete.c:
>> static __init int obsolete_init(void)
>> {
>> 	printk("\e[1;31m""
>> 
>> The following stuff is gonna get removed \e[5;37m SOON: \e[0m
>> 	- cardmgr
>> 	- foobar
>> 	- bweebol
>> 
>> ");
>> 	schedule_timeout(3 * HZ);
>> 	return;
>> }
>
>The kernel console isn't VT102 compatible.  It doesn't understand any
>escape codes, at all.  Neither does sysklogd.  So the above will just
>end up as rubbish on your console.

It will (should) at least show up as nicely as in the C source code.
With escape codes, but largely readable.
If someone knows how to directly spew it to tty0 (the current active console -
most likely tty1), the better.
Anyway, I just wanted to point out how to really highlight it for the user to
see. Although then there would be the distros who obscure it with funky
bootsplash screens. But hopefully, their users would not need to care too much
for old stuff (gets updated through the distro's update mechanism)


Jan
-- 
