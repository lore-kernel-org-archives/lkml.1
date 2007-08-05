Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbXHEUwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbXHEUwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbXHEUwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:52:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbXHEUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:52:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wait_task_zombie: remove unneeded child->signal check
In-Reply-To: Oleg Nesterov's message of  Sunday, 5 August 2007 19:00:42 +0400 <20070805150041.GA2016@tv-sign.ru>
X-Windows: the joke that kills.
Message-Id: <20070805205144.314B04D04C4@magilla.localdomain>
Date: Sun,  5 Aug 2007 13:51:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A zombie must have a valid ->signal, we are going to release it and
> __exit_signal() starts with BUG_ON(!sig).

Yes, this is safe because it's after the EXIT_DEAD check under tasklist_lock.


Thanks,
Roland
