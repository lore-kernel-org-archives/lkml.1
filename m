Return-Path: <linux-kernel-owner+w=401wt.eu-S1422903AbXCBG4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbXCBG4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422905AbXCBG4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:56:19 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1804 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422903AbXCBG4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:56:18 -0500
Date: Fri, 2 Mar 2007 07:54:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scatterlist.h needs types.h
Message-Id: <20070302075410.5b49f260.khali@linux-fr.org>
In-Reply-To: <20070301161106.5687156e.akpm@linux-foundation.org>
References: <20070301135516.5e6b6b29.khali@linux-fr.org>
	<20070301161106.5687156e.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, 1 Mar 2007 16:11:06 -0800, Andrew Morton wrote:
> On Thu, 1 Mar 2007 13:55:16 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Most architectures' scatterlist.h use the type dma_addr_t, but omit
> > to include <asm/types.h> which defines it. This could lead to build
> > failures, so let's add the missing includes.
> 
> _does_ it actually lead to build errors?  If so, 2.6.21.  If not, 2.6.22.

No known build error at the moment, so 2.6.22 is fine with me.

I'm working on a patch cleaning up the inclusion of <linux/pci.h>
across the whole kernel, and this is how I've hit the problem. I'll
post that patch later today for comments.

Thanks,
-- 
Jean Delvare
