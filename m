Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbXEKHc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbXEKHc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXEKHcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:32:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXEKHcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:32:19 -0400
Date: Fri, 11 May 2007 10:29:30 +0200
From: Andi Kleen <ak@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511082930.GP2012@bingen.suse.de>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm guessing (haven't rechecked source) that the cpu_idle() call comes
> about because the top level pgd of a process gets freed very late in
> its exit, and after a great flurry of processes have just exited,
> perhaps there was nothing to free up the accumulation.  Though
> it still strikes me as an odd place to do it.

I always found it odd and probably the wrong place too.
-Andi
