Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXHYAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXHYAWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbXHYAWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:22:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47260 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbXHYAWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:22:00 -0400
Subject: Re: 2.6.23-rc3-mm1
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20070824170702.a2c51084.akpm@linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <46CF695D.1020008@imap.cc>
	 <20070824170702.a2c51084.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 17:21:31 -0700
Message-Id: <1188001291.6163.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 17:07 -0700, Andrew Morton wrote:
> On Sat, 25 Aug 2007 01:27:25 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
> > Am 22.08.2007 11:06 schrieb Andrew Morton:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> > After applying Matthew Wilcox' patch to include/linux/isa.h
> 
> which patch is that?
> 
> > this compiles
> > and boots on my Intel/openSUSE 10.2 test machine but throws out the
> > following messages I don't remember ever seeing with other kernels:
> > 
> > - on console early during boot, also in SuSE's /var/log/boot.msg:
> > 
> > your system time is not correct:
> > Wed Jul 13 13:15:31 UTC 1910
> > setting system time to:
> > Tue Jul 24 00:00:00 UTC 2007

Hrmm. I'm not super familiar w/ SuSE's init scripts, but I'm guessing
that's the ntpdate call. And "Tuesday Jul 24th"? Sounds about a month
off, is this just stale info?


> What architecture?
> 
> if x86_64 then perhaps something went wrong with the old x86_64 dynticks
> leftovers which were in rc3-mm1.  I've just merged a shiny fresh new series
> so perhaps things there got fixed.  Please retest next -mm.
> 
[snip]
> > - from fsck during boot:
> > 
> > /dev/system/root: Superblock last mount time is in the future.  FIXED.
> > /dev/system/root: Superblock last write time is in the future.  FIXED.
> 
> Presumably related to the time problem.


Does this show up before or after the above date stuff? 
Does the issue go away using an older kernel (I want to eliminate easy
stuff like CMOS batteries giving up)?

Also you're not using Linus' CMOS corrupting suspend/resume debugging
trick, right (I'm forgetting the CONFIG name).

thanks
-john


