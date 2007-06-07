Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbXFGPzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbXFGPzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763568AbXFGPy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:54:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbXFGPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:54:56 -0400
Date: Thu, 7 Jun 2007 08:54:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
 internal errnos
In-Reply-To: <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com>
Message-ID: <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
 <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Satoru Takeuchi wrote:
> 
> I tested your patch and my problem didn't occur again, so it seems to my
> this case at least.

Ok. I applied Roland's slightly bigger patch instead, since Ben and Paul
pointed out that some kernel threads depend on dequeue_signal clearing the 
bit. You might want to test that one too (or just get current git), just 
in case there are any differences in behaviour (not bloody likely, but 
still..)

Thanks,

		Linus
