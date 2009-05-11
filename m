Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZEKDTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZEKDTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZEKDTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:19:12 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50124 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZEKDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:19:11 -0400
Message-Id: <200905110319.n4B3J9hc092830@www262.sakura.ne.jp>
Subject: Re: Q: semaphore and kmalloc(GFP_KERNEL)?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 11 May 2009 12:19:09 +0900
References: <200905110230.n4B2UUXk082125@www262.sakura.ne.jp> <20090511115410.B0EA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090511115410.B0EA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 11052009 #1952945, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > Can the kernel detect that we need to let kmalloc() fail and
> > wake up the writer process so that the writer process releases
> > the rw_semaphore and reader processes can continue?
> 
> it can't. Plus it shouldn't.
> some caller don't want kmalloc() failure.

Thanks.
Then, should I move kmalloc(GFP_KERNEL) to outside the lock whenever possible?
(I worry some lock held by the caller interferes kmalloc(GFP_KERNEL).)
