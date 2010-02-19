Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0BSSNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:13:00 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:36789 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0BSSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yDsXluCqsGvWJGFa7N7cWOLPdBaOQblUSRDAZHxyffUqvubyCJaDYzkLBrT2SF8hmM
         7zM1pqKnM0wj+csGbRKPJnPLnNbq2sJEt4f3kBFEjJdxlUUvY2Rdw+rB/VGD3NriuyUR
         L4JGZqe5fc3Zbl7PYuVtCqsr6jX4ne2n80oyc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: [GIT PULL] hw-breakpoint regression fixes
Date: Fri, 19 Feb 2010 19:12:49 +0100
Message-Id: <1266603171-6615-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100219180435.GB4736@in.ibm.com>
References: <20100219180435.GB4736@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      hw-breakpoints: Accept breakpoints on NULL address
      hw-breakpoint: Keep track of dr7 local enable bits


 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/hw_breakpoint.c  |   30 +++++++-----------------------
 arch/x86/kernel/ptrace.c         |    7 +++++--
 3 files changed, 14 insertions(+), 25 deletions(-)
