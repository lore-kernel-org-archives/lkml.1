Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZHSVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZHSVt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZHSVt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:49:28 -0400
Received: from www.tglx.de ([62.245.132.106]:45811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZHSVt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:49:27 -0400
Date: Wed, 19 Aug 2009 23:48:30 +0200 (CEST)
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
       Jon Masters <jcm@redhat.com>
Subject: [ANNOUNCE] 2.6.31-rc6-rt5
In-Reply-To: <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain> <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain> <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
    - update to Linus' latest
 
    - Fixed the Pseries mystery: missed to exclude per cpu timers from
      forced threading so the IPI handlers got threaded

    - cgroup memcontrol preemption problem fixed

So the only known remaining one is ARM highmem

Download locations:

    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.31-rc6
 
Git development branch:
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Gitweb:
    http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.31-rc6
 
Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.31-rc6-rt5 tree, the following patches should be
applied:

    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
    http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.31-rc6.bz2
    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31-rc6-rt5.bz2

Enjoy !

       tglx
