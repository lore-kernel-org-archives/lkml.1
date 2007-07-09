Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXGIVrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXGIVrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXGIVqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:46:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbXGIVqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:46:54 -0400
Date: Mon, 9 Jul 2007 17:46:50 -0400
From: Dave Jones <davej@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the
	last few months
Message-ID: <20070709214650.GE29368@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
	Arjan van de Ven <arjan@linux.intel.com>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com> <468E6F4C.8000601@linux.intel.com> <20070706170210.GA11214@redhat.com> <9264.1184017334@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9264.1184017334@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 05:42:14PM -0400, Valdis.Kletnieks@vt.edu wrote:
 > On Fri, 06 Jul 2007 13:02:10 EDT, Dave Jones said:
 > > On Fri, Jul 06, 2007 at 09:35:24AM -0700, Arjan van de Ven wrote:
 > > 
 > >  > > Where is the ondemand-fix.patch? I can't find any link to it.
 > >  > 
 > >  > just click on it in the graph ;_
 > >  > 
 > >  > it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch 
 > >  > (which is submitted already to the maintainers)
 > > 
 > > Should be in cpufreq.git (and thus, -mm) too, waiting for .23 to open up.
 > 
 > Somebody should fix http://ww.linuxpowertop.org/known.php then, it says:
 > 
 > "The kernels ondemand CPU frequency management function currently has a
 > high-frequency timer that samples to see if the CPU is idle. Intel fixed this
 > and the patches to the kernel to effectively remove this timer are included in
 > Linus' tree as of 2.6.22-rc1."
 > 
 > which confused me no end when I was looking at this stuff and wondering why
 > it was in the -mm tree if Linus already picked it up. :)

There were two sets of fixes to ondemand.  The first round did in fact
go into .22rc1  The others I deemed too late in the cycle to go into .22
(Though they have been flawless, so if there was enough demand (ha!) we could
 even push them to -stable once they're in mainline).

	Dave

-- 
http://www.codemonkey.org.uk
