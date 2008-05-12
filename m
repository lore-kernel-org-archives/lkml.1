Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYELNcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYELNcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYELNbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:31:52 -0400
Received: from trantor.org.uk ([213.146.130.142]:44977 "EHLO
	trantor.trantor.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYELNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:31:51 -0400
Subject: Re: oprofile BUG() in current kernel.
From: Gianni Tedesco <gxt@cs.nott.ac.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
In-Reply-To: <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
References: <1210593756.3708.7.camel@dao.KWGR614>
	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 14:31:45 +0100
Message-Id: <1210599105.3479.1.camel@dao.KWGR614>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 14:19 +0200, Vegard Nossum wrote:
> Hi,
> 
> On Mon, May 12, 2008 at 2:02 PM, Gianni Tedesco <gxt@cs.nott.ac.uk> wrote:
> > This is from Linus' git tree, pulled this morning. To reproduce simply
> >  opcontrol --start
> >
> >  oprofile: using NMI interrupt.
> >  BUG: unable to handle kernel paging request at eff86d58
> >  IP: [<eeb9d508>] :oprofile:alloc_cpu_buffers+0x42/0xd6
> > 
> This looks similar to:
> 
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.0/2845.html

Yes, remarkably similar ;)

> Does reverting 608dfddd845da5ab6accef70154c8910529699f7 fix it for you too?

It does indeed. Thanks for the pointer.

