Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZDQV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZDQV0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZDQV0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:26:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZDQV0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:26:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Fri, 17 Apr 2009 23:25:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904161738030.4042@localhost.localdomain> <20090417012544.GB16126@elte.hu>
In-Reply-To: <20090417012544.GB16126@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172325.49030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > I think you put this in the wrong regression pile:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
> > > Subject		: Oops in drain_array
> > > Submitter	: Bart <mmx@riz.pl>
> > > Date		: 2009-04-14 10:21 (3 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4
> > 
> > Hmm. This one seems like it should be in the "since 2.6.28" camp, since if 
> > I read that one right, it happens with 2.6.29.1.
> > 
> > (I mean sure, it might be new since 2.6.29, but it sounds more likely that 
> > it's already in 2.6.29)
> 
> I'd suspect it's possibly hardware related:
> 
>   http://www.kerneloops.org/search.php?search=free_block&btnG=Function+Search
> 
> Look at the very similar call signatures - spanning almost all 
> kernels back to v2.6.16. There's one spike at .27 - perhaps the same 
> box trying up hard and crashing several times - or a popular distro 
> kernel?
> 
> Or it's a really ancient bug going back to v2.6.16.

I have moved this one onto the list of regressions from 2.6.28.  When it is
confirmed that the bug is older, I'll drop it from there.

Thanks,
Rafael
