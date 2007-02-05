Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbXBECWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbXBECWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXBECWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:22:06 -0500
Received: from qsrv01sl.mx.bigpond.com ([144.140.92.181]:38487 "EHLO
	qsrv01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXBECWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:22:04 -0500
Message-ID: <45C6802D.5040307@bigpond.net.au>
Date: Mon, 05 Feb 2007 10:54:05 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Chris Han <xiphux@gmail.com>, Con Kolivas <kernel@kolivas.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jake Moilanen <moilanen@austin.ibm.com>,
       Paolo Ornati <ornati@fastwebnet.it>, Ingo Molnar <mingo@elte.hu>
Subject: [ANNOUNCE][RFC] PlugSched-6.5 for  2.6.20
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [60.231.44.29] using ID pwil3058@bigpond.net.au at Mon, 5 Feb 2007 00:54:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The main change in this version is a change to the scheduler driver 
interface to take account of recent changes to the load balancing code.

A patch for 2.6.20 is available at:

<http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.20.patch?use_mirror=osdn>

Very Brief Documentation:

You can select a default scheduler at kernel build time.  If you wish to
boot with a scheduler other than the default it can be selected at boot
time by adding:

cpusched=<scheduler>

to the boot command line where <scheduler> is one of: ingosched,
ingo_ll, nicksched, staircase, spa_no_frills, spa_ws, spa_svr, spa_ebs
or zaphod.  If you don't change the default when you build the kernel
the default scheduler will be ingosched (which is the normal scheduler).

The scheduler in force on a running system can be determined by the
contents of:

/proc/scheduler

Control parameters for the scheduler can be read/set via files in:

/sys/cpusched/<scheduler>/

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

