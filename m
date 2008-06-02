Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYFBCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYFBCfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYFBCfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:35:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55964 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753438AbYFBCfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:35:39 -0400
Date: Sun, 1 Jun 2008 21:35:33 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080601213533.ab1c049f.pj@sgi.com>
In-Reply-To: <4841A311.2050008@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>
	<20080529173759.ccbaf8ef.pj@sgi.com>
	<483F3559.1030806@qualcomm.com>
	<20080529191211.080ec5cf.pj@sgi.com>
	<483F8178.7040300@qualcomm.com>
	<20080530015200.f299afed.pj@sgi.com>
	<4841A311.2050008@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> Would you be ok with a patch that exposes (via sysctl
> for example) scheduler balancer mask when cpusets are disabled ?

I wasn't looking for a variant implementation.  Unless this variant
serves some critical purpose that isolcpus can't provide, I would be
against it.  I'm trying to minimize API changes to kernel users.

I am trying to discuss the reasons for or against removing isolcpus.

I just started a separate lkml thread, with a wider audience, to
address this question:

  Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
