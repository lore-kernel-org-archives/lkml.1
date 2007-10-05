Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbXJERl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbXJERl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXJERk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:40:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758445AbXJERk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:40:58 -0400
Date: Fri, 5 Oct 2007 10:40:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: strange@nsk.no-ip.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch available] Re: lguest compilation problem in 2.6.23-rc9
Message-Id: <20071005104009.b836b196.akpm@linux-foundation.org>
In-Reply-To: <20071005091809.d11f8003.randy.dunlap@oracle.com>
References: <20071005152147.GA8160@bit.office.eurotux.com>
	<20071005091809.d11f8003.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007 09:18:09 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > BUILD   arch/i386/boot/bzImage
> > Root device is (254, 3)
> > Setup is 11496 bytes (padded to 11776 bytes).
> > System is 1234 kB
> > Kernel: arch/i386/boot/bzImage is ready  (#2)
> >   Building modules, stage 2.
> >   MODPOST 282 modules
> > ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > Config follows.
> 
> Fixed by
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/move-kasprintfo-to-obj-y.patch
> 
> Need to merge now?

yup, I'll add it to the for-2.6.23 queue.

Which presently consists of

fix-sys_remap_file_pages-bug-at-highmemc15.patch
fix-timer_stats-printout-of-events-sec.patch
longhaul-add-auto-enabled-revid_errata-option.patch
lockstat-documentation.patch
move-kasprintfo-to-obj-y.patch

I'll get those out today.
