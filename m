Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYL3Hlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYL3Hlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYL3Hli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:41:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:17372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYL3Hlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=A9Qhc8pOoR40bEndl2ZA6lCIw7IXxl9cnVMDj8Zr9xHmiRWN2mENOX+xf4RUsbQB72
         hRnXtxp6UAGmEFqBxZag9lZc7hw+F8Ng0FP9xtUA1CnnuSudCJZA4FiC/oYox/4m+XD8
         rrugwuW4KROZpmhMY4zkn+5kgjQUK85ZDpgyQ=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kmemtrace over tracepoints (resubmit)
Date: Tue, 30 Dec 2008 09:41:26 +0200
Message-Id: <cover.1230622068.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

I've figured out a way to minimally modify RCU headers. If you still think
splitting RCU headers is a good idea, let me know, but this is meant to get
kmemtrace in Linus' tree as soon as possible.

I also renamed tracers as Pekka suggested.

Let me know what you think.


	Cheers,
	Eduard


Eduard - Gabriel Munteanu (2):
  RCU: Don't include unnecessary headers, allow kmemtrace w/
    tracepoints.
  kmemtrace: Use tracepoints instead of markers.

 include/linux/kmemtrace.h  |   91 +++++++++++------------------------------
 include/linux/rcuclassic.h |    1 -
 include/linux/rcupdate.h   |    1 -
 include/linux/rcupreempt.h |    2 +-
 include/linux/slab_def.h   |    9 ++--
 include/linux/slub_def.h   |   12 ++----
 lib/Kconfig.debug          |    2 +-
 mm/kmemtrace.c             |   96 ++++++++++++++++++++++++++++++++------------
 mm/slab.c                  |   25 +++++------
 mm/slob.c                  |   27 +++++-------
 mm/slub.c                  |   30 +++++--------
 11 files changed, 140 insertions(+), 156 deletions(-)

