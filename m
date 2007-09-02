Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXIBUxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXIBUxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXIBUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:52:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXIBUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:52:53 -0400
Date: Sun, 2 Sep 2007 13:52:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: 2.6.23-rc4-mm1: unpingable box and NULL dereference at
 tcp_rto_min()
Message-Id: <20070902135245.aed7c7a9.akpm@linux-foundation.org>
In-Reply-To: <20070902023618.GA2537@martell.zuzino.mipt.ru>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070902023618.GA2537@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2 Sep 2007 06:36:19 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> > - dynticks-for-x86_64 has returned
> 
> Good news is that, contary to popular belief, -mm is not horrible piece
> of crap and NO_HZ on x86_64 worked here straight away.

variable.  It at least Works For Me before it goes out.

> 
> The bad news is something knocked off box from the net, then panicked it:

Yeah, the net tree has been quite bad lately.  Unusually bad - it's usually
one of the good ones.

It also breaks a lot of the net driver work in several other trees (I dropped
git-ixgbe.patch wholesale because of this).  But there isn't a lot we can
do about that.  
