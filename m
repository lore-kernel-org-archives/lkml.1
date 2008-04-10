Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYDJJtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYDJJtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYDJJtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:49:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYDJJtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:49:12 -0400
Date: Thu, 10 Apr 2008 11:48:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080410094853.GA12543@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FCF50E.9090703@s5r6.in-berlin.de> <20080410065227.GB30066@elte.hu> <20080410174418.ebfe76c3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410174418.ebfe76c3.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Thu, 10 Apr 2008 08:52:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > what type of conflict do you have there? If it's a new entry then 
> > you might be able to fix it by moving the new entry elsewhere in the 
> > file. Or if i introduced a new entry close to an existing entry you 
> > modify then i could move my new entry elsewhere.
> 
> Commit 523a65f1a7a339e528ca6d6d808516fe195fde03 ("firewire: fw-ohci: 
> add option for remote debugging") in the ieee1394 tree adds a new 
> entry just where the sched tree adds
> 
> source kernel/trace/Kconfig

hm, i think in this specific case the new firewire entry should be added 
after the PROVIDE_OHCI1394_DMA_INIT section. (that's how we extend 
groups of Kconfig entries anyway) The new trace entries in the scheduler 
tree follow that pattern and add the new kernel/trace/Kconfig at the 
right place. So if the firewire entry is added that way this conflict 
could be avoided.

	Ingo
