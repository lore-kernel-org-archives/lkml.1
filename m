Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbZJNKDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbZJNKDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZJNKDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:03:43 -0400
Received: from www.tglx.de ([62.245.132.106]:58264 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbZJNKDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:03:42 -0400
Date: Wed, 14 Oct 2009 12:02:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Subject: [ANNOUNCE] 2.6.31.4-rt14
In-Reply-To: <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain> <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

   - Forward to 2.6.31.4
   - Handle futex spurious wakeups
   - slab fixes for NUMA (peterz)

The slab problem is still not completely resolved. It's hard to
reproduce and was only seen on Nehalem dual socket systems so far. If
you have such a machine you might help providing a back trace, just run

 while true; do hackbench N; done

until it explodes. Adjust N to your system, the larger the
better. Make sure you have a serial console to capture the oops.

Download locations:
  
    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.31
  
Git development branch:
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Gitweb:
    http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.31
 
Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.31.4-rt14 tree, the following patches should be
applied:

    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.4.tar.bz2
    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31.4-rt14.bz2

Enjoy !

      tglx

