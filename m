Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZHNHpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZHNHpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZHNHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:45:09 -0400
Received: from www.tglx.de ([62.245.132.106]:40212 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZHNHpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:45:08 -0400
Date: Fri, 14 Aug 2009 09:44:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Gross <mgross@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RESEND 0/2] pm_qos: remove BKL and de-race
In-Reply-To: <20090813140554.014ce1e0@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0908140855590.1283@localhost.localdomain>
References: <20090813140554.014ce1e0@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan,

On Thu, 13 Aug 2009, Jonathan Corbet wrote:

> Here's a repost of my two-patch set getting rid of the BKL and some
> racy code in pm_qos_params.c.  There's been no changes since the last
> time around other than the addition of a couple of tags.  Patches
> follow, or they can be pulled from:
> 
> 	git://git.lwn.net/linux-2.6.git bkl-removal
> 
> Ingo, you didn't say whether these could find a home in your
> violent-death-to-the-bkl tree until the merge window opens.  So they're
> still looking for a place to rest; I guess I could ask Stephen to take
> the bkl-removal tree back into linux-next, but that seems like
> overkill.

Pulled it into

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kill-the-bkl-really

Thanks,

	tglx
