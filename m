Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0BTJB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:01:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0BTJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:01:55 -0500
Date: Sat, 20 Feb 2010 10:01:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com, rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-ID: <20100220090154.GB11287@basil.fritz.box>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002191222320.26567@router.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 12:22:58PM -0600, Christoph Lameter wrote:
> On Mon, 15 Feb 2010, Nick Piggin wrote:
> 
> > I'm just worried there is still an underlying problem here.
> 
> So am I. What caused the breakage that requires this patchset?

Memory hotadd with a new node being onlined.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
