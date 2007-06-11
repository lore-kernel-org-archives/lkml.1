Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbXFKJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbXFKJEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXFKJED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:04:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbXFKJEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:04:00 -0400
Date: Mon, 11 Jun 2007 11:03:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tarkan Erimer <tarkan@netone.net.tr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070611090348.GA18894@elte.hu>
References: <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr> <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org> <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org> <466D0A12.5030607@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466D0A12.5030607@netone.net.tr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tarkan Erimer <tarkan@netone.net.tr> wrote:

> > (*) And I've been pushing for that since before they even released 
> > it - I walked out on Bill Joy at a private event where they 
> > discussed their horrible previous Java license.
> 
> Thanks for making things more clear :-) Some really strong indications 
> that Sun is very willing to,at least, "Dual-License" the OpenSolaris 
> with GPLv3. I think; in a very short time; we will see when the GPLv3 
> finalized and released.

that would certainly be a good and productive move from them. Note the 
issue that others have pointed out to you: OpenSolaris is probably more 
interested in picking up code from Linux than the other way around! :-) 
You mentioned "dtrace" and "ZFS". Firstly, Linux already has a "dtrace" 
equivalent. Secondly, ZFS might be interesting in theory, although our 
prior experience of having compatibly-licensed filesystems ported over 
to Linux has been pretty negative: XFS ended up being an integration 
nightmare - and that doesnt have to do anything with the qualities of 
XFS (it's one of the cleanest Linux filesystems, if not the cleanest), 
the problem is that components within a kernel are very tightly 
integrated and rarely does it make sense to port over more than just 
drivers or maybe libraries. And that's i guess what OpenSolaris lacks 
and which i suspect it is mostly interested in: lots of nice Linux 
drivers ;-) XFS, the largest Linux filesystem is 100K lines of code - 
and ZFS (i've never seen it) is very likely smaller than that. Linux 
drivers on the other hand, as of today, are _3.7 million_ lines of code 
and enable Linux to run on 99% of the hardware that is produced today. 
Guess which one has the larger strategic significance? ;-)

	Ingo
