Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXEQBFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXEQBFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXEQBFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:05:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57747 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbXEQBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:05:23 -0400
Date: Thu, 17 May 2007 10:04:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, apw@shadowen.org, clameter@sgi.com,
       ak@suse.de, jbarnes@virtuousgeek.org, eric.whitney@hp.com
Subject: Re: [PATCH 2.6.21-rc1-mm1] add check_highest_zone to
 build_zonelists_in_zone_order
Message-Id: <20070517100432.94c39067.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1179345459.5867.31.camel@localhost>
References: <1179345459.5867.31.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 15:57:39 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> 
> [PATCH 2.6.21-rc1-mm1] add check_highest_zone to build_zonelists_in_zone_order
> 
> We missed this in the "change zone order" series.  We need to record
> the highest populated zone, just as build_zonelists_node() does.
> Memory policies apply only to this zone.  Without this, we'll be
> applying policy to all zones, including DMA, I think.  Not having
> thought about it much, I can't claim to understand the downside of
> doing so.
> 
> Also, display selected "policy zone" during boot or reconfig
> of zonelist order, if 'NUMA.  Inquiring minds [might] want to know...
> 
> Cleanup:  remove stale comment in set_zonelist_order()
> 
> Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
>
Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

-Kame

