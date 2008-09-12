Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYILWKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYILWKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYILWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:10:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54358 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYILWKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:10:23 -0400
Date: Sat, 13 Sep 2008 00:14:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080912221418.GA11730@one.firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de> <20080912213053.GR7714@one.firstfloor.org> <alpine.LFD.1.10.0809122345120.13819@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809122345120.13819@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:49:04PM +0200, Thomas Gleixner wrote:
> On Fri, 12 Sep 2008, Andi Kleen wrote:
> > > 1.) what guarantees that we reach user space ?
> > 
> > Broken SLITs don't prevent booting.
> 
> Of course you can guarantee that.

Yes I'm pretty sure:

(a) the kernel does a sanity check on SLITs and replaces them
with a fallback if they're bogus. Even that is not strictly needed
for correctness, just for performance.
(b) SLIT information is only an optimization, but does not really break
anything if it's wrong. In the worst case your scheduler domains
or your zone fallback lists are not quite optimally set up, but
they will still work.

-Andi

-- 
ak@linux.intel.com
