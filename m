Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbXCWJh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbXCWJh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 05:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934275AbXCWJh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 05:37:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934274AbXCWJh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 05:37:57 -0400
Date: Fri, 23 Mar 2007 10:37:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070323093738.GB11577@wotan.suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> <20070323021115.GA11147@wotan.suse.de> <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 08:51:13AM +0100, Michal Piotrowski wrote:
> On 23/03/07, Nick Piggin <npiggin@suse.de> wrote:
> >>
> >> and that in turn points to the kernel log:
> >>
> >>       
> >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log
> >
> >Seems convincing. Michal, can you post your .config, and if you had
> >dynticks and hrtimers enabled, try reproducing without them?
> >
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-config
> 
> I don't know how to reproduce this bug on 2.6.21-rc4.On 2.6.21-rc2-mm1
> it was very simple, just run youtube, bash_shared_mapping etc. In fact
> I didn't see this bug for a week.

OK... for some reason this is listed as a regression against 2.6.21-rc4.

You do have CONFIG_NO_HZ=y, and it is likely to be the cause of your
2.6.21-rc2-mm1 problems, but maybe there have been fixes since then? Ingo?

