Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYHONc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYHONc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbYHONcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:32:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55615 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbYHONcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:32:14 -0400
Date: Fri, 15 Aug 2008 14:32:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
In-Reply-To: <20080815131530.GG19125@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0808151426080.309@blonde.site>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
 <20080815131530.GG19125@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Andi Kleen wrote:
> On Fri, Aug 15, 2008 at 01:58:32PM +0100, Hugh Dickins wrote:
> > Do we actually want these DirectMap lines in the x86 /proc/meminfo?
> > I can see they're interesting to CPA developers and TLB optimizers,
> > but they don't fit its usual "where has all my memory gone?" usage.
> 
> It was intended for the "why is my computer going slower" usage.

Yes, that's what I meant by the TLB optimizers.  But it's going to
be a fractional effect, isn't it, when you're trying to get the last
1% out of the machine?  And in such a case, you might wonder more
what all the 4k ones are actually being used for (no problem at all
if they've ended up behind vmalloced module text).

Hugh
