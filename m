Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXBWLLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXBWLLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbXBWLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:11:54 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35421 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXBWLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:11:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/14] x86_64 irq related fixes and cleanups.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:10:36 -0700
In-Reply-To: <m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 03:51:04 -0700")
Message-ID: <m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My recent ioapic investigation has been painful and has taken me all
over the place.  One of my conclusions is that our code for dealing with
ioapics on i386 and x86_64 is a mess that has been growing for years.

I saw tremendous amounts of fodder for cleanup patches.  Ugh.

When deciding how much to include in the patchset for addressing the irq
migrations problems that have cropped up in the x86_64 code I really
wanted to keep the patchset small and minimal.  But I needed to make
some substantial changes so I would have a low priority IPI I could use
for ensuring irq migration was complete.  When trying to throw out
patches I kept finding things that were either bug fixes or relevant
cleanups to the problem I was addressing.

So this patchset is bigger than I would for addressing the issue irq
migration issue but there is nothing that isn't a simple cleanup or
isn't a real bug fix.  So I think we need it all one way or another.

I have lost track of who has what in which tree or who it makes sense
to send this to.  So this patchset is against Linus's latest git tree.
And hopefully we can include this in 2.6.21. 

Eric
