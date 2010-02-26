Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478Ab0BZRZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:25:19 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:52931 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab0BZRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:25:17 -0500
Date: Fri, 26 Feb 2010 11:24:50 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <20100226155755.GE16335@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1002261123520.7719@router.home>
References: <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi>
 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Andi Kleen wrote:

> > > Memory hotplug with node add never quite worked on x86 before,
> > > for various reasons not related to slab.
> >
> > Ok but why did things break in such a big way?
>
> 1) numa memory hotadd never worked

Well Kamesan indicated that this worked if a cpu became online.

> 2) the rest just bitrotted because nobody tested it.

Yep. David: Can you revise the relevant portions of the patchset and
repost it?

