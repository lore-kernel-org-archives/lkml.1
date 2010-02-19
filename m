Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0BSSWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:22:38 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51242 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0BSSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:22:36 -0500
Date: Fri, 19 Feb 2010 12:22:09 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <20100215103250.GD21783@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002191221110.26567@router.home>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, Andi Kleen wrote:

> > How, may I ask? cpuup_prepare in the hotplug notifier should always
> > run before start_cpu_timer.
>
> I'm not fully sure, but I have the oops to prove it :)

I still suspect that this has something to do with Pekka's changing the
boot order for allocator bootstrap. Can we clarify why these problems
exist before we try band aid?

