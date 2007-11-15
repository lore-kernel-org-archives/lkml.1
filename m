Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXKOOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXKOOYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbXKOOYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:24:43 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52309 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXKOOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:24:42 -0500
Date: Thu, 15 Nov 2007 19:19:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [RFC PATCH 0/3] Refcount Based Cpu Hotplug V3
Message-ID: <20071115134924.GA15282@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
This is Try #3 for the Refcount + Waitqueue based implementation
for cpu-hotplug locking. The earlier versions can be found at

http://lkml.org/lkml/2007/10/24/36
and
http://lkml.org/lkml/2007/10/16/118.

This version drops the patch 4 from the earlier series, 
which was basically removing the CPU_DEAD and CPU_UP_CANCELLED
event handling in the workqueue subsystem. This was based on 
Oleg Nestertov's comments since the problem which the patch
was attempting to solve was more complicated and needs to be looked
into seperately.

The patch series is against v2.6.24-rc2 and has survived 
overnight kern_bench + cpu-offline-online tests on 
- 8 way x86, 
- 8 way x86_64,
- 128 way ppc64 boxes.

The patch series has gone through many iterations 
and looks to have matured in the process.

Andrew, could you please consider it for the next -mm
release if there are no objections ?

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
