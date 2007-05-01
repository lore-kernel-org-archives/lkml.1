Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXEAHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXEAHFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXEAHFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:05:38 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:41238 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbXEAHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:05:36 -0400
Message-ID: <4636E6A5.8040102@bigpond.net.au>
Date: Tue, 01 May 2007 17:05:09 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
CC: Chris Han <xiphux@gmail.com>, Con Kolivas <kernel@kolivas.org>,
       Jake Moilanen <moilanen@austin.ibm.com>,
       Paolo Ornati <ornati@fastwebnet.it>, Ingo Molnar <mingo@elte.hu>
Subject: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [60.231.39.149] using ID pwil3058@bigpond.net.au at Tue, 1 May 2007 07:05:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The main change in this version is to fix bugs introduced to SPA 
schedulers during modifications to handle a recent change to the 
scheduler driver interface to take account of recent changes to the load 
balancing code.

This patch also includes a patch to sis900 code to enable it to boot on 
my system for testing (patch supplied by Neil Horman).

A patch for 2.6.21 is available at:

<http://downloads.sourceforge.net/cpuse/plugsched-6.5.1-for-2.6.21.patch>

and a quilt/gquilt patch series is available at:

<http://downloads.sourceforge.net/cpuse/plugsched-6.5.1-for-2.6.21.patch-series.tar.gz>

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


