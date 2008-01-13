Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYAMU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYAMU0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbYAMUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:25:29 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:60766 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbYAMUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:25:25 -0500
Date: Sun, 13 Jan 2008 21:25:22 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt1
Message-ID: <20080113202522.GD27137@pengutronix.de>
References: <1200250801.9190.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1200250801.9190.7.camel@localhost.localdomain>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:22:16 up 123 days, 12 min, 23 users,  load average: 0.02,
	0.95, 0.96
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 02:00:01PM -0500, Steven Rostedt wrote:
> We are pleased to announce the 2.6.24-rc7-rt1 tree

Works fine on phyCORE-MPC5200B-tiny, here are the latest results:
http://www.pengutronix.de/oselas/realtime/results/20080113-1/

However, when I try to switch on the latency tracer, it ends with the
warnings below. I've added early_printk() stubs in order to make it
link at all.

In file included from kernel/latency_trace.c:27:
include/asm/asm-offsets.h:76:1: warning: "CLONE_VM" redefined
In file included from include/linux/security.h:32,
                 from include/linux/mm.h:15,
                 from kernel/latency_trace.c:7:
include/linux/sched.h:8:1: warning: this is the location of the previous definition
In file included from kernel/latency_trace.c:27:
include/asm/asm-offsets.h:77:1: warning: "CLONE_UNTRACED" redefined
In file included from include/linux/security.h:32,
                 from include/linux/mm.h:15,
                 from kernel/latency_trace.c:7:
include/linux/sched.h:22:1: warning: this is the location of the previous definition
In file included from kernel/latency_trace.c:27:
include/asm/asm-offsets.h:88:1: warning: "TASK_SIZE" redefined
In file included from include/asm/thread_info.h:25,
                 from include/linux/thread_info.h:34,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:85,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from kernel/latency_trace.c:7:
include/asm/processor.h:84:1: warning: this is the location of the previous definition
In file included from kernel/latency_trace.c:27:
include/asm/asm-offsets.h:112:1: warning: "NSEC_PER_SEC" redefined
In file included from include/linux/stat.h:60,
                 from include/linux/fs.h:278,
                 from include/linux/security.h:25,
                 from include/linux/mm.h:15,
                 from kernel/latency_trace.c:7:
include/linux/time.h:37:1: warning: this is the location of the previous definition
In file included from kernel/latency_trace.c:27:
include/asm/asm-offsets.h:115:1: warning: "PGD_TABLE_SIZE" redefined
In file included from include/asm/pgtable.h:15,
                 from include/linux/mm.h:38,
                 from kernel/latency_trace.c:7:
include/asm/pgtable-ppc32.h:91:1: warning: this is the location of the previous definition
  CC [M]  fs/ext2/balloc.o
kernel/latency_trace.c: In function 'check_wakeup_timing':
kernel/latency_trace.c:2240: warning: format '%016lx' expects type 'long unsigned int', but argument 2 has type 'cycle_t'

Robert
-- 
 Robert Schwebel              |  http://www.pengutronix.de
 OSADL Testlab @ Pengutronix  |  http://www.osadl.org

