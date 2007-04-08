Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXDHSwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXDHSwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXDHSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:52:39 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:46702 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXDHSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:52:38 -0400
Message-ID: <461939A4.2020305@gmail.com>
Date: Sun, 08 Apr 2007 20:51:16 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu>
In-Reply-To: <20070408104125.GB11123@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2007 12:41 PM, Ingo Molnar wrote:

> this is pretty hard to get right, and the most objective way to change 
> it is to do it testcase-driven. FYI, interactivity tweaking has been 
> gradual, the last bigger round of interactivity changes were done a year 
> ago:
> 
>  commit 5ce74abe788a26698876e66b9c9ce7e7acc25413
>  Author: Mike Galbraith <efault@gmx.de>
>  Date:   Mon Apr 10 22:52:44 2006 -0700
> 
>      [PATCH] sched: fix interactive task starvation
> 
> (and a few smaller tweaks since then too.)
> 
> and that change from Mike responded to a testcase. Mike's latest changes 
> (the ones you just tested) were mostly driven by actual testcases too, 
> which measured long-term timeslice distribution fairness.

Ah yes, that one. Here's the next one in that series:

commit f1adad78dd2fc8edaa513e0bde92b4c64340245c
Author: Linus Torvalds <torvalds@g5.osdl.org>
Date:   Sun May 21 18:54:09 2006 -0700

     Revert "[PATCH] sched: fix interactive task starvation"

It personally had me wonder if _anyone_ was testing this stuff...

Rene.

