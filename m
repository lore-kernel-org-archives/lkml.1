Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbXD0QZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbXD0QZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbXD0QZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:25:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbXD0QZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:25:09 -0400
Message-ID: <463223C0.1080409@redhat.com>
Date: Fri, 27 Apr 2007 12:24:32 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <alpine.DEB.0.98.0704271139190.29118@sigma.j-a-k-j.com> <alpine.LFD.0.98.0704270852480.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704270852480.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, John Anthony Kazos Jr. wrote:
>> Could[/should] this stuff be changed from ratios to amounts? Or a quick 
>> boot-time test to use a ratio if the memory is small and an amount (like 
>> tax brackets, I would expect) if it's great?
> 
> Yes, the "percentage" thing was likely wrong. That said, there *is* some 
> correlation between "lots of memory" and "high-end machine", and that in 
> turn tends to correlate with "fast disk", so I don't think the percentage 
> approach is really *horribly* wrong.
> 
> The main issue with the percentage is that we do export them as such 
> through the /proc/ interface, and they are easy to change and understand. 
> So changing them to amounts is non-trivial if you also want to support the 
> old interfaces - and the advantage isn't obvious enough that it's a 
> clear-cut case.
> 

We could add a new "limit" field, though. If it defaulted to 0 (unlimited)
the default behavior wouldn't change.
