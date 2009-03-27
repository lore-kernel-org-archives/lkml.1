Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZC0Kla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZC0Kla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZC0KlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:41:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbZC0KlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:41:19 -0400
Date: Fri, 27 Mar 2009 11:40:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Simek <monstr@monstr.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [GIT PULL] Microblaze initial pack
Message-ID: <20090327104045.GA11518@elte.hu>
References: <49CC8A41.4060503@monstr.eu> <20090327103032.GA12485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327103032.GA12485@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I have noticed one relatively big (but easily fixable) commit 
> structure problem in this tree.
> 
> All of the commits have these tags:
> 
>     Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
>     Acked-by: John Linn <john.linn@xilinx.com>
>     Acked-by: John Williams<john.williams@petalogix.com>

I forgot to mention that in any case _your_ signoff as the submitter 
of this tree should be in all commits as well.

So for example this (sample) chain would be fine:

     Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
     Acked-by: John Linn <john.linn@xilinx.com>
     Acked-by: John Williams<john.williams@petalogix.com>
     Signed-off-by: Michal Simek <monstr@monstr.eu>

It's not enough to be listed as the author in the commit. (In any 
case please see Documentation/SubmittingPatches and the DCO 1.1.)

Also, a minor stylistic detail, please fix this:

     John Williams<john.williams@petalogix.com>

to:

     John Williams <john.williams@petalogix.com>

Thanks,

	Ingo
