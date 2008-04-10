Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYDJJvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYDJJvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYDJJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:51:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYDJJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:51:29 -0400
Date: Thu, 10 Apr 2008 11:51:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: debug Kconfig option (was Re: linux-next: Tree for April 9)
Message-ID: <20080410095112.GB12543@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FCF50E.9090703@s5r6.in-berlin.de> <20080410065227.GB30066@elte.hu> <20080410174418.ebfe76c3.sfr@canb.auug.org.au> <tkrat.991b1750a56cf2e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.991b1750a56cf2e9@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > Commit 523a65f1a7a339e528ca6d6d808516fe195fde03 ("firewire: fw-ohci: 
> > add option for remote debugging") in the ieee1394 tree adds a new 
> > entry just where the sched tree adds
> > 
> > source kernel/trace/Kconfig
> 
> I grab this opportunity to ask the list: Would you prefer the remote 
> debugging option in the kernel hacking menu (as in the commit), or 
> rather in the respective driver submenu?

it's great stuff! I very much think it's fine in lib/Kconfig.debug - we 
need prominence of debugging options. (they are used way too 
infrequently)

My only suggestion would be to move the new entry below the existing 
firewire entry (PROVIDE_OHCI1394_DMA_INIT) there - which also happens to 
avoid this particular merge conflict.

	Ingo
