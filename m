Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbYB1UOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbYB1UOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763448AbYB1UNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:13:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57011 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764028AbYB1UNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:13:42 -0500
Date: Thu, 28 Feb 2008 14:13:39 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228141339.b83ae00f.pj@sgi.com>
In-Reply-To: <47C7155C.5060607@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<20080228104637.GA9129@elte.hu>
	<47C7155C.5060607@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> I like the concept of the "boot" set. But we still need a separate "system"
> flag. Users should not have to move cpu back into the "boot" set to allow for
> kernel (irqs, etc) activity on it. And it's just more explicit and clear that way.

Good point -- a "boot" cpuset might be 4 CPUs out of 256 CPUs, just for running
the classic Unix load (daemons, init, login, ...).  But irq's might need to go
to most CPUs, except for some (dare I use the word) isolated CPUs.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
