Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYENHCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYENHCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYENHC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:02:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbYENHC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:02:27 -0400
Date: Wed, 14 May 2008 09:01:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, acme@redhat.com, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>,
       Pavel Roskin <proski@gnu.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/2]: Add sparc64 ftrace support.
Message-ID: <20080514070148.GA10549@elte.hu>
References: <20080513.220652.24245811.davem@davemloft.net> <20080514063055.GA21369@elte.hu> <20080514065156.GA3159@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514065156.GA3159@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > [ also a patch integration detail: i took the liberty to move your 
> >   arch/sparc64/Kconfig's HAVE_FTRACE to the first spot of the SPARC64 
> >   select lines as per the second patch below - your patch had a conflict 
> >   against current mainline (which probably means you already changed 
> >   this file in your Sparc64 tree). By moving that entry to the first 
> >   line your tree and the ftrace tree should auto-merge just fine without 
> >   any conflicts. ]
> 
> When adding new select entries I try to keep them sorted 
> alphabetically. It will not solve all the merge issues but as the list 
> grows this should help. At least betterthan adding to the end.

yep, i do that too in other cases - but the list here is very short. 
Btw., i also do sorting for include file names, such as in 
kernel/trace/ftrace.c:

 #include <linux/stop_machine.h>
 #include <linux/clocksource.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kthread.h>
 #include <linux/hardirq.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/sysctl.h>
 #include <linux/hash.h>
 #include <linux/ctype.h>
 #include <linux/list.h>

 #include "trace.h"

(i also sort by length to make it visually more appealing. "Reverse 
christmas tree" sorting ;-)

[ and yes, linux/uaccess.h is mis-sorted - fixed. ]

	Ingo
