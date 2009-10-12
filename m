Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZJLIEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZJLIEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZJLIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:04:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40469 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZJLIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:04:18 -0400
Date: Mon, 12 Oct 2009 17:03:29 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.32-rc2-xxx: bdev_lock: inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091011010910.7fdf357c.akpm@linux-foundation.org>
References: <20091007035310.GA30833@x200> <20091011010910.7fdf357c.akpm@linux-foundation.org>
Message-Id: <20091012170147.E4C7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yep, we knew about that but appear to have forgotten about it.  Let's just
> revert:

Grr, sorry, I was stupid.
thank you Andrew!


> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Revert
> 
>     commit 71de1ccbe1fb40203edd3beb473f8580d917d2ca
>     Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>     AuthorDate: Mon Sep 21 17:01:31 2009 -0700
>     Commit:     Linus Torvalds <torvalds@linux-foundation.org>
>     CommitDate: Tue Sep 22 07:17:27 2009 -0700
> 
>         mm: oom analysis: add buffer cache information to show_free_areas()



