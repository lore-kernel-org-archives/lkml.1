Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0BOKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 05:32:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57440 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0BOKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 05:32:51 -0500
Date: Mon, 15 Feb 2010 11:32:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-ID: <20100215103250.GD21783@one.firstfloor.org>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215061535.GI5723@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 05:15:35PM +1100, Nick Piggin wrote:
> On Thu, Feb 11, 2010 at 09:54:04PM +0100, Andi Kleen wrote:
> > 
> > cache_reap can run before the node is set up and then reference a NULL 
> > l3 list. Check for this explicitely and just continue. The node
> > will be eventually set up.
> 
> How, may I ask? cpuup_prepare in the hotplug notifier should always
> run before start_cpu_timer.

I'm not fully sure, but I have the oops to prove it :)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
