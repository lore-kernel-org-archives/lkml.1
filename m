Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZIZR2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZIZR2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 13:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZIZR2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 13:28:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZIZR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 13:28:01 -0400
Date: Sat, 26 Sep 2009 19:28:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090926172802.GS30185@one.firstfloor.org>
References: <20090926162046.GQ30185@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926162046.GQ30185@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 10:20:05AM -0700, H. Peter Anvin wrote:
> It doesn't help adjusting NODES_SHIFT - we're already operating in the stressed condition for which NODES_WIDTH == 0 (external node number.)
> 
> As such, NUMA vs !NUMA is a red herring - it's really about SPARSEMEM.
> 
> (Disclaimer: I have no access to the code at the moment and I only have my cell phone email, but I had to deal with this for another issue recently enough.)

You're right. In theory we could just set the sparsemem block really
large on NUMAQ because it doesn't support memory hotadd anyways, so needing
less bits.  But Linus' simple patch is also a solution.

Of course the issue might come up again when someone else needs another
page flags bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
