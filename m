Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbYD2LLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbYD2LLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYD2LL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:11:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49851 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYD2LL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:11:26 -0400
Date: Tue, 29 Apr 2008 20:11:26 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.  take2
Cc: kosaki.motohiro@jp.fujitsu.com, Shi Weihua <shiwh@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080429104318.GA9622@csn.ul.ie>
References: <20080429171457.3543.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080429104318.GA9622@csn.ul.ie>
Message-Id: <20080429200710.354B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see what you mean. The headers for a node with no populated zones looks
> a bit odd. I was briefly thrown by the check for N_HIGH_MEMORY wondering
> why it was not a check for N_NORMAL_MEMORY. A double-check showed that
> N_NORMAL_MEMORY only has meaning on CONFIG_HIGHMEM machines and a check for
> "any memory on the node" should use N_HIGH_MEMORY which is what you do.
> 
> So, your patch looks correct but unfortunately it is whitespace-damaged
> and would not apply as-is. I included a whitespace-fixed version below for
> convenience with a slightly clearer leader which I have acked.

Oops, very sorry.
I'll check my MUA settings again.

and, very thank you for your excellent cleanups.



