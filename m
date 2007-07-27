Return-Path: <linux-kernel-owner+w=401wt.eu-S937903AbXG0WG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937903AbXG0WG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765481AbXG0WGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:06:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58392 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765465AbXG0WGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:06:49 -0400
Date: Sat, 28 Jul 2007 07:06:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com, nickpiggin@yahoo.com.au, Zoltan.Menyhart@bull.net
Subject: Re: [PATCH] flush cache fixes for ia64 [1/2] migration fix
Message-Id: <20070728070609.3a775842.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0707270934300.15619@schroedinger.engr.sgi.com>
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
	<20070727133843.6cd3f57a.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0707270934300.15619@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 09:39:16 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> This will have no effect on x86_64, ia64 and i386. Maybe useful for 
> virtually mapped platforms (parisc)?
> 
yes.

- Kame

> asm-ia64/cacheflush.c
> 
> #define flush_icache_page(vma,page)             do { } while (0)
> 
> Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
