Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbXIKJQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbXIKJQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762049AbXIKJQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:16:09 -0400
Received: from www.osadl.org ([213.239.205.134]:51475 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759909AbXIKJQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:16:07 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070911013512.8d62220e.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <20070910144740.4eba2fda.akpm@linux-foundation.org>
	 <1189492636.25767.62.camel@chaos>
	 <20070911000001.30f8590b.akpm@linux-foundation.org>
	 <1189495400.25767.81.camel@chaos> <1189496840.22589.1.camel@chaos>
	 <20070911012005.4df3ddf4.akpm@linux-foundation.org>
	 <20070911013512.8d62220e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 11:16:04 +0200
Message-Id: <1189502164.6262.7.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 01:35 -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2007 01:20:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > > I went back to the original patch which I sent to Linus and it matches
> > > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > > must have been something else in the tree which I tested which fixed the
> > > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > > 
> > > > > Can you think what would cause the symptoms which I described?  
> > > > 
> > > > It seems that time is not updated. Timer interrupt not active or some
> > > > other odd thing. I figure out what's going on when I find a box which
> > > > exposes the problem.
> > 
> > 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> 
> Len's current tree fixes it too.  Maybe we just need to merge the acpi tree?

Did you enable CONFIG_CPU_IDLE after you applied git-acpi to rc6 ?

	tglx


