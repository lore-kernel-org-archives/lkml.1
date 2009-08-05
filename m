Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZHEVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZHEVnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZHEVnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:43:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZHEVnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:43:13 -0400
Date: Wed, 5 Aug 2009 23:42:27 +0200
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] linux-2.6.31-rc5-rt1.1
Message-ID: <20090805214227.GA6732@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>While Thomas Gleixner is away at summer camp, Clark Williams and myself
>decided to release an unofficial preempt-rt kernel to prevent the -rt code from
>developing bit rot. Unofficial until Thomas either blesses it with some Weizen
or slaps us with a large stinkin' trout.
>
>We are pleased to present
>
>-linux-2.6.31-rc5-rt1.1
>
>This kernel is an incremental release.
>It rebases linux-2.6.31-rc4-rt1 to linux-2.6.31-rc5
>In-addition we added the following patches
>
>- stacktrace-dump_out_last_preempt_disable_locations.patch
>- futex_wait_requeue_pi_commentary_corrections.patch
>- hw_lat-simple-solution-001.patch
>
>stacktrace-dump_out_last_preempt_disable_locations.patch
>is a rewrite by Steven Rostedt of an Ingo Molnar patch. It is useful for
>tracing, since it shows the last location that preemption was disabled.
>
>futex_wait_requeue_pi_commentary_corrections.patch
>Was posted to the rt-users list by Darren Hart to fix some of the comments in
>his futex code.
>
>hw_lat-simple-solution-001.patch
>Is a fix from Luis Claudio R.Goncalves for the hardware latency detector.
>It fixes a problem where wake_up was called with irqs disabled.
>Jon Masters will be pushing some form of it upstream.
>
>Information on the RT patch can be found at:
>http://rt.wiki.kernel.org/index.php/Main_Page
>
>Download location
>git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-linux.git
>
>Branch Name
>linux-2.6.31-rc5-rt1.1

We are also making this available as a patch here:
http://www.kernel.org/pub/linux/kernel/people/clrkwllms/rt-unofficial/patch-2.6.31-rc5-rt1.1.bz2

To build the 2.6.31-rc5-rt1.1 tree, the following patches shouuld be applied.

http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.31-rc5.bz2
http://www.kernel.org/pub/linux/kernel/people/clrkwllms/rt-unofficial/patch-2.6.31-rc5-rt1.1.bz2

Thanks!



