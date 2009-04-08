Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZDHIji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZDHIji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZDHIjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:39:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56046 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZDHIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:39:19 -0400
Date: Wed, 8 Apr 2009 17:37:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Fix documentation
Message-Id: <20090408173747.ce4bc8cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090408083327.GE4069@in.ibm.com>
References: <20090408071817.GD4069@in.ibm.com>
	<20090408162528.97b20427.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408083327.GE4069@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 14:03:27 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> > > -a. Enable control of both RSS (mapped) and Page Cache (unmapped) pages
> > > +a. Enable control of RSS (mapped), Page Cache (unmapped) and Swap cache
> > > +   (unmapped) pages.
> >       Enable control of Anonymous memory, Page Cache and Swap Cache. 
> > ?
> 
> I feel without the terms 'mapped' and 'unmaapped', the story of the memory
> controller is not complete :)
> 
Hmm ?.
     Anonymoys memory, File Cache(both of mapped/unmapped), SwapCache.
(At doing user support, explaining SwapCache is difficult sometimes ;)

I don't have serious concern, anyway.


> > 
> > > +pgpgin		- # of pages paged in (equivalent to # of charging events).
> > > +pgpgout		- # of pages paged out (equivalent to # of uncharging events).
> > > +active_anon	- # of bytes of anonymous memory on active lru list.
> >                                 anonymous memory + shared memory(tmpfs) + SwapCache.
> 
> Ok.
> 
> >                           Seeing acitive/inactive_file, how about swap-backed memory ?
> 
> Not sure what you are hinting at here.
> 
Ah, sorry. I just thought swap-backed v.s. file-backed pages explains all.

Thanks,
-Kame

