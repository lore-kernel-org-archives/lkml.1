Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbXKUIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbXKUIrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXKUIrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:47:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49964 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbXKUIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:47:04 -0500
Date: Wed, 21 Nov 2007 17:49:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
Message-Id: <20071121174948.2269d02f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 17:42:15 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hi, Andrew
> 
> I got following result in 'sync' command.
> It was too slow. (memory controller config is off ;)
> I attaches my .config.
> ==
> [2.6.24-rc3-mm1]
> [kamezawa@dr-test2 ~]$ dd if=/dev/zero of=./tmpfile bs=4096 count=100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 1.46706 seconds, 279 MB/s
> [kamezawa@dr-test2 ~]$ time sync
> 
> real    3m6.440s
> user    0m0.000s
> sys     0m0.133s
> 
Ah, one of cpu shows 100% iowait in 'top' command while this.

-Kame

