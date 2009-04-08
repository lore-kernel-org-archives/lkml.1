Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZDHX5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZDHX5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZDHX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:57:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59109 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZDHX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:57:40 -0400
Date: Thu, 9 Apr 2009 08:56:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Fix documentation
Message-Id: <20090409085608.7912886f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090408093401.GF4069@in.ibm.com>
References: <20090408071817.GD4069@in.ibm.com>
	<20090408162528.97b20427.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408093401.GF4069@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 15:04:01 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> On Wed, Apr 08, 2009 at 04:25:28PM +0900, KAMEZAWA Hiroyuki wrote:
> > Thank you, very helpful. but some nitpicks.
> > 
> > 
> > On Wed, 8 Apr 2009 12:48:17 +0530
> > Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> > 
> > > memcg: Fix documentation.
> > > 
> > > The description about various statistics from memory.stat is not accurate
> > > and confusing at times.
> > > 
> > > +active_anon	- # of bytes of anonymous memory on active lru list.
> >                                 anonymous memory + shared memory(tmpfs) + SwapCache.
> 
> Since these stats are for user consumption, I think we need not explicitly
> mention the inclusion of tmpfs pages here. What do you think ?
> 
Maybe it's better.
Anyway, this information is the same to what /proc/meminfo shows.

Thanks,
-Kame

