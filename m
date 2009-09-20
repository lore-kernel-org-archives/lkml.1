Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZITQPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZITQPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZITQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:15:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:50884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZITQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:15:10 -0400
Date: Sun, 20 Sep 2009 18:12:48 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, ahpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Subject: [git pull] 4 timechart feature patches
Message-ID: <20090920181248.464c9193@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small timechart updated; a few new features and an improvement in performance
that makes inkscape not as slow as it was before.

patches will be posted as reply to this email

The following changes since commit f85b2af8c53ed0f5e0d1008dcea33888d6e22c45:
  Ingo Molnar (1):
        Merge branch 'out-of-tree'

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-timechart master

Arjan van de Ven (4):
      perf timechart: Show the name of the waker/wakee in timechart
      perf timechart: Show the duration of scheduler delays in the SVG
      perf util: Make the timechart SVG width dynamic
      perf util: SVG performance improvements

 tools/perf/Documentation/perf-timechart.txt |    3 +
 tools/perf/builtin-timechart.c              |   23 +++--
 tools/perf/util/svghelper.c                 |  170 +++++++++++++++++++++-----
 tools/perf/util/svghelper.h                 |   11 +-
 4 files changed, 162 insertions(+), 45 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
