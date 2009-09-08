Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZIHJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZIHJPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZIHJPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZIHJPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:15:18 -0400
Date: Tue, 8 Sep 2009 11:14:01 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: lkml <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linuxtronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novells.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Jon Masters <jcm@redhat.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Mark Knecht <markknecht@gmail.com>
Subject: [ANNOUNCE] 2.6.31-rc9-rt9.1
Message-ID: <alpine.LFD.2.00.0909081049430.31237@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While Thomas Gleixner is on vacation, we decided to release another 
incremental real-time kernel. This is for those of you who want to run 
Linus' latest release, but still want the real-time patches.

So, this is simply a merge of 2.6.31-rc8-rt9 with 2.6.31-rc9.
In addition, we added the tracing / ring-buffer patches for the latency 
tracer from Steven Rostedt, modified by Arnaldo Carvalho de Melo 
for real-time. In addition, Clark Williams added an extra commit to 
clean-up some compile problems.

There were a few other patches that we could have added, but 
since the purpose of this is just to keep the current -rt code running on 
the latest release from Linus, we decided to play it conservatively - 
we'll let Thomas do the heavy lifting we he comes back from vacation.

You can download it at the following locations:

Git location:
git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-linux.git
Git branch: linux-2.6.31-rc9-rt9.1

Or in patch form here:
http://www.kernel.org/pub/linux/kernel/people/clrkwllms/rt-unofficial/patch-2.6.31-rc9-rt9.1.bz2

As usual, please report any problems to linux-kernel@vger.kernel.org and 
you can cc linux-rt-users@vger.kernel.org too.

Enjoy!

John Kacur
Clark Williams

