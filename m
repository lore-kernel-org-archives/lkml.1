Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZKWFwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZKWFwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 00:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZKWFwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 00:52:44 -0500
Received: from ozlabs.org ([203.10.76.45]:56467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZKWFwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 00:52:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19210.9003.670537.492493@cargo.ozlabs.ibm.com>
Date: Mon, 23 Nov 2009 16:52:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] perf_event patches
In-Reply-To: <20091120211942.676891948@chello.nl>
References: <20091120211942.676891948@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Some perf patches, most resulting from chasing Corey's scale issue.
> 
> There's still one issue open with that and that is that we're reading
> ->total_time_{enabled,running} without serialization.
> 
> Please have a thorough look at 7-14.
> 
> It also removes all the system_state == STATE_RUNNING muck from
> everywhere and it still boots, which leaves me wondering what changed to
> not make things go boom.

Nice series!  At a quickish look it all looks fine to me.  I'd give
you acked-bys, but Ingo has already committed them all.

Paul.
