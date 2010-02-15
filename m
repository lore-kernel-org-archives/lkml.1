Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0BOPam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:30:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0BOPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:30:41 -0500
To: Nick Piggin <npiggin@suse.de>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
From: Andi Kleen <andi@firstfloor.org>
References: <20100211953.850854588@firstfloor.org>
	<20100211205404.085FEB1978@basil.firstfloor.org>
	<20100215061535.GI5723@laptop>
	<20100215103250.GD21783@one.firstfloor.org>
	<20100215104135.GM5723@laptop>
	<20100215105253.GE21783@one.firstfloor.org>
	<20100215110135.GN5723@laptop>
Date: Mon, 15 Feb 2010 16:30:38 +0100
In-Reply-To: <20100215110135.GN5723@laptop> (Nick Piggin's message of "Mon, 15 Feb 2010 22:01:36 +1100")
Message-ID: <87bpfqms81.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> Hmm, but it should, because if cpuup_prepare fails  then the
> CPU_ONLINE notifiers should never be called I think.

That's true.
  
-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
