Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYI3Mlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYI3Mlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYI3Ml1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:41:27 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:54079 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYI3Ml0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:41:26 -0400
Subject: Re: [PATCH 00/30] Swap over NFS -v18
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080724140042.408642539@chello.nl>
References: <20080724140042.408642539@chello.nl>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 14:41:16 +0200
Message-Id: <1222778476.9044.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 16:00 +0200, Peter Zijlstra wrote:
> Latest version of the swap over nfs work.
> 
> Patches are against: v2.6.26-rc8-mm1
> 
> I still need to write some more comments in the reservation code.
> 
> Pekka, it uses ksize(), please have a look.
> 
> This version also deals with network namespaces.
> Two things where I could do with some suggestsion:
> 
>   - currently the sysctl code uses current->nrproxy.net_ns to obtain
>     the current network namespace
> 
>   - the ipv6 route cache code has some initialization order issues

Daniel, have you ever found time to look at my namespace issues?

