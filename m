Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXK2DjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXK2DjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXK2DjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:39:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33335 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbXK2DjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:39:08 -0500
Date: Thu, 29 Nov 2007 12:42:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
Message-Id: <20071129124207.b59ae745.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071129033328.20E5F1CFEAA@siro.lan>
References: <20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
	<20071129033328.20E5F1CFEAA@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 12:33:28 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> > +static inline struct mem_cgroup_per_zone *
> > +mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
> > +{
> > +	if (!mem->info.nodeinfo[nid])
> 
> can this be true?
> 
> YAMAMOTO Takashi

When I set early_init=1, I added that check.
BUG_ON() is better ?

Thanks,
-Kame

