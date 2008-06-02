Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYFBCjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYFBCjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYFBCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:39:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51282 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753058AbYFBCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:39:16 -0400
Date: Sun, 1 Jun 2008 21:39:13 -0500
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080601213913.8faee53e.pj@sgi.com>
In-Reply-To: <1212312113.24826.63.camel@lappy.programming.kicks-ass.net>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>
	<20080529173759.ccbaf8ef.pj@sgi.com>
	<483F3559.1030806@qualcomm.com>
	<20080529191211.080ec5cf.pj@sgi.com>
	<483F8178.7040300@qualcomm.com>
	<20080530015200.f299afed.pj@sgi.com>
	<4841A311.2050008@qualcomm.com>
	<1212312113.24826.63.camel@lappy.programming.kicks-ass.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> let just get rid of it.

I object to "just" (as in suddenly, without deprecation or prior
warning) removing user space visible kernel features, unless we
have some good reason why we can't take a more methodical approach,
deprecating first.

But I've said that before.

I just started a separate lkml thread, with a wider audience, to
address this question:

  Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
