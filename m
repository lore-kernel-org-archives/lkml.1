Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYFJV6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYFJV6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYFJV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:58:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbYFJV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:58:24 -0400
Date: Tue, 10 Jun 2008 14:57:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: riel@redhat.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 17/25] Mlocked Pages are non-reclaimable
Message-Id: <20080610145706.4a921cfa.akpm@linux-foundation.org>
In-Reply-To: <1213134197.6872.49.camel@lts-notebook>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.522708682@redhat.com>
	<20080606180746.6c2b5288.akpm@linux-foundation.org>
	<20080610033130.GK19404@wotan.suse.de>
	<20080610171400.149886cf@cuia.bos.redhat.com>
	<1213134197.6872.49.camel@lts-notebook>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 17:43:17 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Couple of related items:
> 
> + 26-rc5-mm1 + a small fix to the double unlock_page() in
> shrink_page_list() has been running for a couple of hours on my 32G,
> 16cpu ia64 numa platform w/o error.  Seems to have survived the merge
> into -mm, despite the issues Andrew has raised.

oh goody, thanks.  Johannes's bootmem rewrite is holding up
surprisingly well.

gee test.kernel.org takes a long time.

> + on same platform, Mel Gorman's mminit debug code is reporting that
> we're using 22 page flags with Noreclaim, Mlock and PAGEFLAGS_EXTENDED
> configured.

what is "Mel Gorman's mminit debug code"?
