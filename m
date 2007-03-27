Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXC0HJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXC0HJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXC0HJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:09:22 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45079 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXC0HJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:09:21 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
In-reply-to: <20070326174535.4f21bed3.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 17:45:35 -0700)
Subject: Re: [patch] add file position info to proc
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu> <20070326174535.4f21bed3.akpm@linux-foundation.org>
Message-Id: <E1HW5nH-0003P1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 09:08:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> 
> fs/proc/base.c: In function 'proc_lookupfdinfo':
> fs/proc/base.c:1584: warning: passing argument 3 of 'proc_lookupfd_common' from incompatible pointer type
> fs/proc/base.c: In function 'proc_readfdinfo':
> fs/proc/base.c:1590: warning: passing argument 4 of 'proc_readfd_common' from incompatible pointer type
> 
> If taken, that callback into proc_lookupfd_common() will crash the kernel.

Ugh.  Some constification in -mm that I hadn't noticed.  Resending.

Thanks,
Miklos
