Return-Path: <linux-kernel-owner+w=401wt.eu-S935262AbXG0PTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262AbXG0PTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbXG0PTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:19:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57415 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXG0PTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:19:02 -0400
Date: Sat, 28 Jul 2007 00:18:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Zoltan.Menyhart@bull.net, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com,
       nickpiggin@yahoo.com.au, clameter@sgi.com
Subject: Re: [PATCH] flush cache fixes for ia64 [2/2] sync icache dcache
Message-Id: <20070728001819.617080ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070728000223.31492de4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
	<20070727133936.36b047cd.kamezawa.hiroyu@jp.fujitsu.com>
	<46A9FE3B.7070402@bull.net>
	<20070728000223.31492de4.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 00:02:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 27 Jul 2007 16:16:27 +0200
> Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:
> 
> > Do you really need a "sync_icache_dcache()" in "do_wp_page()"?
> > I guess it is only needed when the EXEC bit of the PTE gets turned on.
> > 
> Ah, sorry. do_wp_page() without page copy (reuse case) doesn't need sync.
> 
> About page copy case
> There was an issue that Java receives SIGILL because lazy_mmu_prot_update()
> is called before set_pte(). Then, Only do_wp_page() calls lazy_mmu_prot_update()
            after....
Sorry..

-Kame
> before set_pte().
> 
