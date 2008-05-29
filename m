Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYE2Faj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYE2Faj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 01:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYE2Faa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 01:30:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbYE2Fa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 01:30:29 -0400
Date: Thu, 29 May 2008 00:30:19 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org, maxk@qualcomm.com
Subject: Re: [PATCH] [sched] Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080529003019.985de0ab.pj@sgi.com>
In-Reply-To: <1211926006-11559-3-git-send-email-maxk@qualcomm.com>
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>
	<1211926006-11559-2-git-send-email-maxk@qualcomm.com>
	<1211926006-11559-3-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> -marked isolated using the kernel boot time "isolcpus=" argument.

Yeah ... a hack ... but I suspect some folks use it.

I'm reluctant to discard features visible to users, unless
they are getting in the way of more serious stuff.

I'd have figured that this hack was not all that much of
a pain to the kernel code.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
