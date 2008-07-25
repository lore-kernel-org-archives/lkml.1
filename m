Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGYJcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGYJcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYGYJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:31:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45640 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYGYJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:31:50 -0400
Date: Fri, 25 Jul 2008 18:29:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/30] mm: __GFP_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080724141530.060638861@chello.nl>
References: <20080724140042.408642539@chello.nl> <20080724141530.060638861@chello.nl>
Message-Id: <20080725180305.86A9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> __GFP_MEMALLOC will allow the allocation to disregard the watermarks, 
> much like PF_MEMALLOC.
> 
> It allows one to pass along the memalloc state in object related allocation
> flags as opposed to task related flags, such as sk->sk_allocation.

Is this properly name?
page alloc is always "mem alloc".

you wrote comment as "Use emergency reserves" and 
this flag works to turn on ALLOC_NO_WATERMARKS.

then, __GFP_NO_WATERMARK or __GFP_EMERGENCY are better?




