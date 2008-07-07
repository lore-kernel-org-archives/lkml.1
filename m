Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYGGQa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYGGQa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYGGQai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:30:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39301 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYGGQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:30:38 -0400
Date: Mon, 7 Jul 2008 18:43:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
Message-ID: <20080707164303.GD20428@one.firstfloor.org>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org> <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com> <486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org> <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com> <m3zlotx587.fsf@gravicappa.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3zlotx587.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 02:12:56PM +0200, Vitaly Mayatskikh wrote:
> Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:
> 
> >> one), by limiting the byte-for-byte one to be within a page, but that 
> >> would be a "future enhancement" thing.
> >
> > Btw, how much does it cost to CPU to do a fault? Can it be compared with
> > average time of find_vma()?
> 
> Remark: this is for preventing fault in memset, not byte-to-byte copy.

memset never faults.

The current code doesn't handle it and it never happened.

-Andi
