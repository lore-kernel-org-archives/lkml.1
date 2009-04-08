Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZDHJeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZDHJeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZDHJd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:33:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53376 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZDHJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:33:56 -0400
Date: Wed, 8 Apr 2009 15:04:01 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Fix documentation
Message-ID: <20090408093401.GF4069@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090408071817.GD4069@in.ibm.com> <20090408162528.97b20427.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408162528.97b20427.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:25:28PM +0900, KAMEZAWA Hiroyuki wrote:
> Thank you, very helpful. but some nitpicks.
> 
> 
> On Wed, 8 Apr 2009 12:48:17 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > memcg: Fix documentation.
> > 
> > The description about various statistics from memory.stat is not accurate
> > and confusing at times.
> > 
> > +active_anon	- # of bytes of anonymous memory on active lru list.
>                                 anonymous memory + shared memory(tmpfs) + SwapCache.

Since these stats are for user consumption, I think we need not explicitly
mention the inclusion of tmpfs pages here. What do you think ?

Regards,
Bharata.
