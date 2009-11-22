Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZKVSG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZKVSG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 13:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZKVSGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 13:06:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZKVSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 13:06:55 -0500
Date: Sun, 22 Nov 2009 19:06:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
 cnt32_to_63().
Message-ID: <20091122180616.GB24711@elte.hu>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
 <20091122081328.GB24558@elte.hu>
 <4B0925BD.6070507@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0925BD.6070507@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Ingo Molnar wrote:
> 
> >>+config HR_SCHED_CLOCK
> >>+	bool "High Resolution sched_clock()"
> >>+	depends on CSRC_R4K
> >>+	default n
> >>+	help
> >>+	  This option enables the MIPS c0 count based high resolution
> >>+	  sched_clock().
> >>+
> >>+	  If you need a ns precision timestamp, You are recommended to enable
> >>+	  this option. For example, If you are using the Ftrace subsystem to do
> 
>   s/If/if/
> 
> >>diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
> >>index e95a3cd..4e52cca 100644
> >>--- a/arch/mips/kernel/csrc-r4k.c
> >>+++ b/arch/mips/kernel/csrc-r4k.c
> >>@@ -6,10 +6,64 @@
> >>  * Copyright (C) 2007 by Ralf Baechle
> >>  */
> >> #include <linux/clocksource.h>
> >>+#include <linux/cnt32_to_63.h>
> >>+#include <linux/timer.h>
> >> #include <linux/init.h>
> >> #include <asm/time.h>
> >>+/*
> >>+ * MIPS' sched_clock implementation.
> >
> >s/MIPS'/MIPS's
> 
>   MIPS's is not really a proper English. :-)

AFAIK 'MIPS' is not the plural of 'MIP' (but an acronym ending with 
'S'), hence the possessive form would be MIPS's.

It doesnt matter much i guess ;-)

	Ingo
