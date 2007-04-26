Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXDZAuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXDZAuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXDZAuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:50:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39569 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXDZAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:50:45 -0400
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
From: john stultz <johnstul@us.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, ak@suse.de,
       linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>
In-Reply-To: <200704252033.06288.lenb@kernel.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070425040605.6d6b4a82.akpm@linux-foundation.org>
	 <1177524532.6401.17.camel@localhost.localdomain>
	 <200704252033.06288.lenb@kernel.org>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 17:49:33 -0700
Message-Id: <1177548573.6401.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 20:33 -0400, Len Brown wrote:
> On Wednesday 25 April 2007 14:08, john stultz wrote:
> > On Wed, 2007-04-25 at 04:06 -0700, Andrew Morton wrote:
> > > On Mon, 23 Apr 2007 23:49:09 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> > > > Subject    : acpi_pm clocksource loses time on x86-64
> > > > References : http://lkml.org/lkml/2007/4/17/143
> > > > Submitter  : Mikael Pettersson <mikpe@it.uu.se>
> > > > Handled-By : John Stultz <johnstul@us.ibm.com>
> > > > Status     : problem is being debugged
> > 
> > 
> > The ACPI PM one is *really* odd as its the same clocksource driver on
> > both arches. I had Mikael cut out the clocksource frequency adjustments,
> > and confirmed both i386 and x86_64 are using the same base freq
> > (confirmed via printks).
> 
> If this chipset's PM-timer loses "several minutes per hour" on x86_64,
> I would expect it to do the same on i386.  I can't imagine what the
> difference could be.  Any possibility it is the 24-bit version
> and we do something funky on wraparound?

No, we assume the PM timer wraps at 24 bits and mask it as such on all
systems.

-john

