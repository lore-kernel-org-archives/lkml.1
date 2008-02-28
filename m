Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYB1RrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYB1RrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYB1RrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:47:06 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbYB1RrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:47:05 -0500
Date: Thu, 28 Feb 2008 11:47:00 -0600
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228114700.c9ecf1f0.pj@sgi.com>
In-Reply-To: <20080228104637.GA9129@elte.hu>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<20080228104637.GA9129@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> ( an initscripts approach, while i'm sure it works, would always be a
>   bit fragile

Agreed.  In the early days of cpusets, (1) the less I put in the kernel,
the easier it was to get those first patches accepted, and (2) the more
there was that remained for me to code in user space, where my employer
could provide better, leading edge, products for a profit.

Overtime, these user space features that prove their worth, but that
were difficult to code in the most usable and robust manner in user
space, such as boot cpusets here, and, on another thread, cpuset
relative NUMA mempolicies, naturally migrate to the kernel, for wider
availability.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
