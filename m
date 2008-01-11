Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbYAKPhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbYAKPhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbYAKPhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:37:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058AbYAKPhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:37:38 -0500
Date: Fri, 11 Jan 2008 10:37:30 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080111103730.2153590a@bree.surriel.com>
In-Reply-To: <20080111122225.FD59.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080111122225.FD59.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 12:59:31 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Rik
> 
> > -static inline long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
> > -					struct zone *zone, int priority)
> > +static inline long mem_cgroup_calc_reclaim(struct mem_cgroup *mem,
> > +					struct zone *zone, int priority,
> > +					int active, int file)
> >  {
> >  	return 0;
> >  }
> 
> it can't compile if memcgroup turn off.

Doh!  Good point.

Thank you for pointing out this error.  I applied your fix to my tree,
it will be in the next version.

-- 
All rights reversed.
