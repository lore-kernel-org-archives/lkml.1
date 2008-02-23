Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYBWSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYBWSr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbYBWSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:47:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbYBWSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:47:50 -0500
Date: Sat, 23 Feb 2008 10:46:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080223104611.a3430285.akpm@linux-foundation.org>
In-Reply-To: <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 13:51:34 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >  Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
> >  your distributor already did it for you.
> 
> Have you tried sysprof? It's really nice to setup and use compared to
> oprofile when profiling user-space.

Wanna see how I use oprofile?

box:/home/akpm> akpm-oprofile gcc t.c
Daemon not running
Daemon not running
Using 2.6+ OProfile kernel interface.
Reading module info.
Using log file /var/lib/oprofile/oprofiled.log
Daemon started.
Profiler running.
t.c:6:12: error: token ""x"" is not valid in preprocessor expressions

real    0m0.262s
user    0m0.004s
sys     0m0.004s
Stopping profiling.
Stopping profiling.
Killing daemon.
CPU: CPU with timer interrupt, speed 0 MHz (estimated)
Profiling through timer interrupt
samples  %        symbol name
625      99.2063  mwait_idle
1         0.1587  __handle_mm_fault
1         0.1587  clear_page
1         0.1587  do_page_fault
1         0.1587  flush_tlb_page
1         0.1587  pfn_valid
box:/home/akpm> 


One thirteen-character command!  Why?  Because I actually got off my butt
and wrote a script to hide low-level details.  I wrote the thing five years
ago and don't remember anything about what's in it.

I didn't need to write a new kernel module to enable that
thirteen-character shell script, and I don't believe one needs to write a
new kernel module to put a nice easy-to-use GUI around oprofile either.


This is one of those i-cant-believe-im-having-this-discussion discussions.
