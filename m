Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYB1IIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYB1IIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYB1IIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:08:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48521 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753733AbYB1IIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:08:14 -0500
Date: Thu, 28 Feb 2008 02:08:08 -0600
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228020808.3fd22f77.pj@sgi.com>
In-Reply-To: <20080228075010.GA28781@elte.hu>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> nice work Peter

agreed

> i've queued up your patches in sched-devel.git

Before this patchset gets too far, I'd like to decide on whether to
adapt my suggestion to call that per-cpuset flag 'cpus_system' (or
anything else with 'cpu' in it, perhaps 'system_cpus' would be more
idiomatic), rather than the tad too generic 'system'.

People doing 'ls /dev/cpuset' should be able to half-way guess
what things do, just from their name.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
