Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXIYQ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXIYQ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXIYQ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:58:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXIYQ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:58:54 -0400
Date: Tue, 25 Sep 2007 12:58:34 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg.Chandler@wellsfargo.com,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more}
	ARM/StrongARM
Message-ID: <20070925165834.GE2769@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Greg.Chandler@wellsfargo.com, cpufreq@lists.linux.org.uk,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	Andi Kleen <ak@suse.de>
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com> <20070925073132.GA29127@flint.arm.linux.org.uk> <20070925143651.GA2769@redhat.com> <20070925095229.d1aec1a5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925095229.d1aec1a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 09:52:29AM -0700, Andrew Morton wrote:
 > On Tue, 25 Sep 2007 10:36:51 -0400 Dave Jones <davej@redhat.com> wrote:
 > > 
 > > commit 184c44d2049c4db7ef6ec65794546954da2c6a0e
 > > Author: Andrew Morton <akpm@linux-foundation.org>
 > > Date:   Wed May 2 19:27:08 2007 +0200
 > > 
 > >     [PATCH] x86-64: fix x86_64-mm-sched-clock-share
 > >     
 > >     Fix for the following patch. Provide dummy cpufreq functions when
 > >     CPUFREQ is not compiled in.
 > >     
 > >     Cc: Andi Kleen <ak@suse.de>
 > >     Cc: Dave Jones <davej@codemonkey.org.uk>
 > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 > >     Signed-off-by: Andi Kleen <ak@suse.de>
 > > 
 > > I don't remember seeing any problem here, so I'm not entirely sure what
 > > this was supposed to be fixing.  Perhaps the -mm-esque patch name
 > > will provide Andrew/Andi clues. It lacks sufficient information for
 > > my brain to guess what the problem was.
 > 
 > Oh geeze.  sched-clock-share went through about 18 different versions, was
 > merged, unmerged, remerged, dropped, etc.  I don't recall at what stage in
 > this mess the above fix was inserted, sorry.
 > 
 > > "Fix for the following patch" is also something that really should
 > > never be added to a git changelog too, because 'next' means absolutely
 > > nothing to me, nor I expect 99% of changelog readers.
 > 
 > 184c44d2049c4db7ef6ec65794546954da2c6a0e should never have existed,
 > actually.  I intended that Andi fold it into the base patch prior to
 > sending it to Linus.  He normally does that, but it looks like this
 > one was handled as a standalone commit for some reason.

So lets see what happens if we revert it ?

	Dave

-- 
http://www.codemonkey.org.uk
