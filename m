Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbXC0TkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbXC0TkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXC0TkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:40:07 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:50136 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXC0TkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:40:06 -0400
Subject: Re: [PATCH -rt] fix setting of preempt_max_latency and
	preempt_thresh on 64 bit systems
From: Steven Rostedt <rostedt@goodmis.org>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070327191542.GA15514@rhlx01.hs-esslingen.de>
References: <1175015947.19634.6.camel@localhost.localdomain>
	 <20070327191542.GA15514@rhlx01.hs-esslingen.de>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 15:39:52 -0400
Message-Id: <1175024392.19634.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 21:15 +0200, Andreas Mohr wrote:

> Maybe fix up all the other myriads of sysctl entries which use a rather
> non-precise generic sizeof(int) as well?
> Or doesn't that make sense?

No, it does make sense

> Maybe this is because it's security relevant and you'd better make sure
> to know *exactly* the number of integers a buffer's length is supposed to be?

This is the problem. I was going to put some more time and clean up all
the stuff in there, but it will take more time than I currently have.
Since I would need to audit all the variables, and see how they would
interact in every arch.

-- Steve


