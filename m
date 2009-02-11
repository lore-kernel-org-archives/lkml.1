Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZBKWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZBKWpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZBKWpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:45:18 -0500
Received: from www.tglx.de ([62.245.132.106]:33961 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbZBKWpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:45:16 -0500
Date: Wed, 11 Feb 2009 23:43:44 +0100 (CET)
From: Thomas Gleixner <tglx@tglx.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [Announce] 2.6.29-rc4-rt1
Message-ID: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a 1.5 years sabbatical from preempt-rt we are pleased to
announce a refactored preempt-rt patch against linux-2.6.29-rc4.

The patch is working on x86 (32 and 64bit) but we have not yet updated
ARM, PPC and MIPS (work in progress).

We also dropped some experimental features of the base preempt-rt
queue 2.6.26.8-rt15 simply because we wanted to survive the forward
port over 3 kernel releases with the least amount of surprises. These
features (e.g. multiple reader PI locks) are not essential for the
preempt-rt functionality and need some serious overhaul anyway.

The interested -rt observer might have noticed that we based our work
on the 2.6.26.8-rt15 patch queue and did not pick the git-rt tree
which is based on 2.6.28. The reason for this is that we wanted to pick
the most stable patch queue and the git-rt tree has a lot of rewritten
new code. Our work is not making the work which was done over the last
months in the git-rt tree obsolete, quite the contrary: we want to
provide a stable yet latest-kernel based foundation and integrate those
changes gradually, as they become ready.

The further plan for the new -rt series is to merge it fully into git
and integrate it into the -tip git tree so it gets the same treatment
as all of our -tip based work: fully automated compile and boot
testing. Furthermore an automated multi architecture -rt performance
regression test based on the same infrastructure is currently being
built.

The integration into the -tip tree also allows us to seperate out parts
of -rt which are ready for mainline more easily and integrate them
with our usual propagation to mainline.

The structure of the patches is likely to change over the next days
when we tackle the git integration, but we appreciate your feedback in
the form of comments, bugreports and patches.

Enough said. You can find the new patches at the following location:

  http://www.kernel.org/pub/linux/kernel/projects/rt/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29-rc4-rt1 tree, the following patches should be
applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc4.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc4-rt1.bz2

The broken out patches are also available at the same download
location.

Enjoy !

      Thomas, Ingo
