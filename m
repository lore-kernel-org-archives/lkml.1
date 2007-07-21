Return-Path: <linux-kernel-owner+w=401wt.eu-S933733AbXGUV3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbXGUV3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761672AbXGUV2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:28:55 -0400
Received: from toq7.bellnexxia.net ([209.226.175.203]:42959 "EHLO
	toq7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760669AbXGUV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:28:54 -0400
Subject: Re: [PATCH 1/3] readahead: drop behind
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <20070721210051.975382000@chello.nl>
References: <20070721210005.000228000@chello.nl>
	 <20070721210051.975382000@chello.nl>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 16:29:07 -0400
Message-Id: <1185049747.27915.8.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-21-07 at 23:00 +0200, Peter Zijlstra wrote:
> plain text document attachment (readahead-useonce.patch)
> Use the read-ahead code to provide hints to page reclaim.
> 
> This patch has the potential to solve the streaming-IO trashes my
> desktop problem.
> 
> It tries to aggressively reclaim pages that were loaded in a strong
> sequential pattern and have been consumed. Thereby limiting the damage
> to the current resident set.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

With the fadvise change, it looks like the right solution to me.

The patches are for which kernel? They doesn't apply cleanly to
2.6.22.1.

It would be useful to have a temporary /proc tunable to enable/disable
the heuristic to help test the effects.


- Eric


