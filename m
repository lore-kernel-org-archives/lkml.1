Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXH2VnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXH2VnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbXH2VnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:43:11 -0400
Received: from web32611.mail.mud.yahoo.com ([68.142.207.238]:30972 "HELO
	web32611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751896AbXH2VnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:43:10 -0400
X-YMail-OSG: BaaonMcVM1lfGO1tNDpqOkbhXOX7kcfAxEJXRnx.g1KpSqWyhVPiVI1HhS42zVBjUAAj21UbYG6Txc8SpWvJVy3AJw--
X-RocketYMMF: knobi.rm
Date: Wed, 29 Aug 2007 14:43:08 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour - next try
To: Chuck Ebbert <cebbert@redhat.com>, spamtrap@knobisoft.de
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
In-Reply-To: <46D59DE2.2070405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <856205.2054.qm@web32611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chuck Ebbert <cebbert@redhat.com> wrote:

> On 08/28/2007 11:53 AM, Martin Knoblauch wrote:
> > 
> >  The basic setup is a dual x86_64 box with 8 GB of memory. The
> DL380
> > has a HW RAID5, made from 4x72GB disks and about 100 MB write
> cache.
> > The performance of the block device with O_DIRECT is about 90
> MB/sec.
> > 
> >  The problematic behaviour comes when we are moving large files
> through
> > the system. The file usage in this case is mostly "use once" or
> > streaming. As soon as the amount of file data is larger than 7.5
> GB, we
> > see occasional unresponsiveness of the system (e.g. no more ssh
> > connections into the box) of more than 1 or 2 minutes (!) duration
> > (kernels up to 2.6.19). Load goes up, mainly due to pdflush threads
> and
> > some other poor guys being in "D" state.
> 
> Try booting with "mem=4096M", "mem=2048M", ...
> 
> 

 hmm. I tried 1024M a while ago and IIRC did not see a lot [any]
difference. But as it is no big deal, I will repeat it tomorrow.

 Just curious - what are you expecting? Why should it help?

Thanks
Martin


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
