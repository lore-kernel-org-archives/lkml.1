Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXDTBUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXDTBUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXDTBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:20:24 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:58220 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXDTBUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:20:24 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Renice X for cpu schedulers
Date: Thu, 19 Apr 2007 21:17:36 -0400
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <200704200110.47974.kernel@kolivas.org> <46279585.4010409@rtr.ca>
In-Reply-To: <46279585.4010409@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192117.38428.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 12:15, Mark Lord wrote:
> Con Kolivas wrote:
> > On Thursday 19 April 2007 23:17, Mark Lord wrote:
> >> Con Kolivas wrote:
> >> s go ahead and think up great ideas for other ways of metering out cpu
> >>
> >>> bandwidth for different purposes, but for X, given the absurd simplicity
> >>> of renicing, why keep fighting it? Again I reiterate that most users of
> >>> SD have not found the need to renice X anyway except if they stick to old
> >>> habits of make -j4 on uniprocessor and the like, and I expect that those
> >>> on CFS and Nicksched would also have similar experiences.
> >> Just plain "make" (no -j2 or -j9999) is enough to kill interactivity
> >> on my 2GHz P-M single-core non-HT machine with SD.
> >>
> >> But with the very first posted version of CFS by Ingo,
> >> I can do "make -j2" no problem and still have a nicely interactive destop.
> > 
> > Cool. Then there's clearly a bug with SD that manifests on your machine as it 
> > should not have that effect at all (and doesn't on other people's machines). 
> > I suggest trying the latest version which fixes some bugs.
> 
> SD just doesn't do nearly as good as the stock scheduler, or CFS, here.
> 
> I'm quite likely one of the few single-CPU/non-HT testers of this stuff.
> If it should ever get more widely used I think we'd hear a lot more complaints.

amd64 UP here.  SD with several makes running works just fine.

Ed Tomlinson
