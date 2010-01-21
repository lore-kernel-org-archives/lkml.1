Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271Ab0AUVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0AUVYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841Ab0AUVYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:24:17 -0500
Received: from www.tglx.de ([62.245.132.106]:60364 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab0AUVYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:24:16 -0500
Date: Thu, 21 Jan 2010 22:23:10 +0100 (CET)
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
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [ANNOUNCE] 2.6.31.12-rt20
In-Reply-To: <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
   - forward to 2.6.31.12

   - large number of RCU assumption fixes vs. cred and tasklist_lock

   - Priority Inheritance POSIX compliance fix

   - workaround for Priority Protection POSIX compliance problem

   - misc. fixlets here and there

It took quite a while to get this update out for various reasons:

   - mainline merge of the locking infrastructure changes which are a
     further milestone on the way to full rt integration. That merge
     will shave off a large portion of the rt patch (don't worry, we
     have enough new and exiting stuff in the pipeline to keep the
     patch size large enough)

  - fixing RCU assumptions in mainline and backport to 31-rt

  - lots of brain twisting around the POSIX scheduling policy
    compliance problems which got reported vs. Priority
    Inheritance/Protection

  - an extended christmas break and the resulting email backlog

  - our new housemate: http://tglx.de/~tglx/housemate.png

Further plans:

  - a last big feature for 31-rt is pending, which is worth a separate
    release: Nick Piggins VFS scalability patches. I'm still running
    tests on that, so no promise.

  - I'm going to switch 31-rt into maintaince mode (with or without
    the VFS patches) and concentrate on getting .33-rcX-rt out. Yes,
    there will be no .32-rt. The reason is simply that the locking
    changes which got merged into .33 are making my life easier and
    are the base to sort out more ready for the mainline stuff.

Download locations:
   
   http://rt.et.redhat.com/download/ (temporary out of sync)
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.31
  
Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.31
  
Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.31.12-rt20 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.12.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31.12-rt20.bz2

Enjoy !

      tglx
