Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0BXPtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:49:47 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59467 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0BXPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:49:46 -0500
Date: Wed, 24 Feb 2010 09:49:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <20100220090154.GB11287@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1002240949140.26771@router.home>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org>
 <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, Andi Kleen wrote:

> On Fri, Feb 19, 2010 at 12:22:58PM -0600, Christoph Lameter wrote:
> > On Mon, 15 Feb 2010, Nick Piggin wrote:
> >
> > > I'm just worried there is still an underlying problem here.
> >
> > So am I. What caused the breakage that requires this patchset?
>
> Memory hotadd with a new node being onlined.

That used to work fine.

