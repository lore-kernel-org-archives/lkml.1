Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYIARCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYIARCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYIARCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:02:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:41612 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYIARCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k7G7L9ffKIvdoufx3l9MtFMuHibf8+qOKefsWfkzsfiFmCk8pHVEFSab0L6A9EbbQJ
         qq3X5Zr/99o0RLGqyWei/OcAObM2EwTt1uCqsUJW2NpwopcE7pq7aN5cjE13mDSpCV1j
         4OSLgM6XnbWQIzcXGF77lddeJxr8+3WGoCl1M=
Message-ID: <3f9a31f40809011002k572450ffg90654912f3e1fa2a@mail.gmail.com>
Date: Mon, 1 Sep 2008 13:02:29 -0400
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Francois Romieu" <romieu@fr.zoreil.com>
In-Reply-To: <N8SeMoDzuxC.A.xIG.OkbuIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	 <N8SeMoDzuxC.A.xIG.OkbuIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Sat, Aug 30, 2008 at 3:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11271
> Subject         : BUG: fealnx in 2.6.27-rc1
> Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> Date            : 2008-08-05 14:58 (26 days old)
> References      : http://marc.info/?l=linux-netdev&m=121794762016830&w=4
>                  http://lkml.org/lkml/2008/8/10/98
> Handled-By      : Francois Romieu <romieu@fr.zoreil.com>
>
>
>

Still exists in 2.6.27-rc5 :

NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b35000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b36000:  80000000 80000000 80000000 80000000 0000 80000000
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x120/0x199()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-rc5 #135
 [<c011c977>] warn_on_slowpath+0x40/0x63
 [<c0132dba>] tick_program_event+0x2b/0x4a
 [<c012e194>] hrtimer_interrupt+0x136/0x15e
 [<c010f69d>] smp_apic_timer_interrupt+0x6e/0x79
 [<c01036c0>] apic_timer_interrupt+0x28/0x30
 [<c038cfcc>] _spin_unlock_irqrestore+0x4/0x1a
 [<c027b064>] tx_timeout+0x194/0x1d1
 [<c0335085>] dev_watchdog+0x120/0x199
 [<c012f96b>] getnstimeofday+0x32/0xb7
 [<c0132060>] clockevents_program_event+0xca/0xd9
 [<c0334f65>] dev_watchdog+0x0/0x199
 [<c01234af>] run_timer_softirq+0xf5/0x14a
 [<c01201ac>] __do_softirq+0x5d/0xc1
 [<c0120242>] do_softirq+0x32/0x36
 [<c0120378>] irq_exit+0x35/0x40
 [<c010f69d>] smp_apic_timer_interrupt+0x6e/0x79
 [<c01036c0>] apic_timer_interrupt+0x28/0x30
 [<c010756c>] mwait_idle+0x32/0x3a
 [<c0101924>] cpu_idle+0x5c/0x84
 =======================
---[ end trace 65e715863a9afa94 ]---

Thank you,

Jaswinder Singh.
