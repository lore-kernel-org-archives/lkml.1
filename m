Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbYBBTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbYBBTG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYBBTGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:06:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYBBTGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:06:17 -0500
Date: Sat, 2 Feb 2008 20:05:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [patch] pci: pci_enable_device_bars() fix (was: [GIT PATCH]
	PCI patches for 2.6.24)
Message-ID: <20080202190558.GB27927@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <20080202184441.GA12301@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202184441.GA12301@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> > ( This call has been introduced upstream 3 weeks ago by commit
> >   8a4df120b07, but the PCI tree has apparently not been fully 
> >   re-tested with Linus-latest since that point. )
> 
> Wait, my testing caught this.  I made the change to the patch myself, 
> adding the needed conversion to my tree, it's here, on my disk!
> 
> Oh crap, I never checked it in.
> 
> /me goes off to sulk in shame.

you might want to join the (sizable) club of us deeply ashamed people 
who recently introduced upstream build failures :-/

	Ingo
