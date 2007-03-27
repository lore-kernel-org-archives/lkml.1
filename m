Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXC0I3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXC0I3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXC0I3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:29:10 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40678 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXC0I3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:29:09 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20070327001834.04dc375e.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 27 Mar 2007 00:18:34 -0800)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
	<20070326234957.6b287dda.akpm@linux-foundation.org>
	<E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu> <20070327001834.04dc375e.akpm@linux-foundation.org>
Message-Id: <E1HW72O-0003ZB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 10:28:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But Peter Staubach says a RH custumer has files written thorugh mmap,
> > which are not being backed up.
> 
> Yes, I expect the backup problem is the major real-world hurt arising from
> this bug.
> 
> But I expect we could adequately plug that problem at munmap()-time.  Or,
> better, do_wp_page().  As I said - half-assed.
> 
> It's a question if whether the backup problem is the only thing which is hurting
> in the real-world, or if people have other problems.
> 
> (In fact, what's wrong with doing it in do_wp_page()?

It's rather more expensive, than just toggling a bit.

Let me work on it a bit more.  I think I can make the current patch
more palatable.

Miklos
