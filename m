Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXC3Qb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXC3Qb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXC3Qb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:31:27 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:1265 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753895AbXC3Qb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:31:27 -0400
Date: Fri, 30 Mar 2007 20:31:24 +0400
From: Vitaly Bordug <vbordug@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] fixed_init(): BUG: at drivers/base/core.c:120
 device_release(), was: "2.6.21-rc5: known regressions"
Message-ID: <20070330203124.7106ae08@vitb.ru.mvista.com>
In-Reply-To: <20070330142514.GA15327@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070327015929.GY16477@stusta.de>
	<20070330120416.GA19373@elte.hu>
	<20070330120657.GA21271@elte.hu>
	<20070330141856.GB10387@suse.de>
	<20070330142514.GA15327@elte.hu>
Organization: MontaVista software, Inc.
X-Mailer: Sylpheed-Claws 2.0.0cvs8 (GTK+ 2.6.10; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 16:25:14 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > > Device 'fixed@10:1' does not have a release() function, it is broken and must be fixed.
> > > BUG: at drivers/base/core.c:120 device_release()
> > >  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
> > >  [<c01063e2>] show_trace+0x12/0x14
> > >  [<c01063f8>] dump_stack+0x14/0x16
> > >  [<c063cddf>] device_release+0x7c/0x7e
> > >  [<c0476c32>] kobject_cleanup+0x44/0x5e
> > >  [<c0476c57>] kobject_release+0xb/0xd
> > >  [<c04773ef>] kref_put+0x63/0x71
> > >  [<c0476757>] kobject_put+0x14/0x16
> > >  [<c063ceef>] put_device+0x11/0x13
> > >  [<c063d943>] device_unregister+0x12/0x15
> > >  [<c07337d1>] fixed_mdio_register_device+0x210/0x23b
> > >  [<c1b6d6c1>] fixed_init+0x2f/0x33
> > >  [<c1b31a2d>] init+0x15d/0x2bd
> > >  [<c0105bc3>] kernel_thread_helper+0x7/0x10
> > 
> > That means that whatever driver has fixed_mdio_register_device() in it 
> > is broken and needs to be fixed.
> 
> that would be drivers/net/phy/fixed.c.
> 

OK, I'll look into it, thanks for pointing out.

> > It is independant from your previous question about unregistering the 
> > device from within module_init().
> 
> (yes - hence the different subject line, etc.)
> 


-- 
Sincerely, 
Vitaly
