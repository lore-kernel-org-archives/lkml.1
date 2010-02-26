Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302Ab0BZLnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:43:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34032 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934718Ab0BZLnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:43:13 -0500
Date: Fri, 26 Feb 2010 12:43:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-ID: <20100226114312.GB16335@basil.fritz.box>
References: <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <alpine.DEB.2.00.1002251315010.3501@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251627040.18861@router.home> <4B87A62E.5030307@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87A62E.5030307@cs.helsinki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:45:02PM +0200, Pekka Enberg wrote:
> Christoph Lameter kirjoitti:
>>> kmalloc_node() in generic kernel code.  All that is done under
>>> MEM_GOING_ONLINE and not MEM_ONLINE, which is why I suggest the first and
>>> fourth patch in this series may not be necessary if we prevent setting the
>>> bit in the nodemask or building the zonelists until the slab nodelists are
>>> ready.
>>
>> That sounds good.
>
> Andi?

Well if Christoph wants to submit a better patch that is tested and solves
the problems he can do that.

if he doesn't then I think my patch kit which has been tested
is the best alternative currently.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
