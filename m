Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYGUWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYGUWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYGUWA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:00:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbYGUWAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:00:55 -0400
Date: Mon, 21 Jul 2008 14:20:28 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq pull request for .27
Message-ID: <20080721182028.GA3472@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ next

 arch/x86/kernel/cpu/cpufreq/powernow-k7.h |    1 -
 drivers/cpufreq/cpufreq.c                 |   45 +++++++++++++++-------------
 drivers/cpufreq/cpufreq_stats.c           |   24 ++++++++--------
 drivers/cpufreq/freq_table.c              |   12 ++++----
 include/linux/cpufreq.h                   |    3 --
 5 files changed, 42 insertions(+), 43 deletions(-)

commit 48adcf148c83faa41999fb0b3524299c4e160fd9
Author: Adrian Bunk <bunk@kernel.org>
Date:   Tue May 20 01:03:16 2008 +0300

    [CPUFREQ] cpufreq: remove CVS keywords
    
    This patch removes CVS keywords that weren't updated for a long time
    from comments.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 7a6aedfac98c6d54ecf97ca1ffb1e6a1f3d26aea
Author: Mike Travis <travis@sgi.com>
Date:   Tue Mar 25 15:06:53 2008 -0700

    [CPUFREQ] change cpu freq arrays to per_cpu variables
    
    Change cpufreq_policy and cpufreq_governor pointer tables
    from arrays to per_cpu variables in the cpufreq subsystem.
    
    Also some minor complaints from checkpatch.pl fixed.
    
    Based on:
        git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Dave Jones <davej@redhat.com>


-- 
http://www.codemonkey.org.uk
