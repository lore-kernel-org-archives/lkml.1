Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZFMGnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZFMGnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZFMGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:43:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZFMGnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:43:06 -0400
Date: Sat, 13 Jun 2009 08:42:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, mchan@broadcom.com,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
	reference to `ip6_route_output'
Message-ID: <20090613064253.GB14034@elte.hu>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com> <20090612.165108.110857018.davem@davemloft.net> <1244851393.26552.1.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244851393.26552.1.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2009-06-12 at 16:51 -0700, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Fri, 12 Jun 2009 11:43:48 -0700
> > 
> > > Ingo Molnar wrote:
> > >> today's -git fails to build with ipv6 disabled (x86):
> > >> 
> > >>   drivers/built-in.o: In function `cnic_get_v6_route':
> > >>   cnic.c:(.text+0x104c42): undefined reference to `ip6_route_output'
> > >> 
> > >> introduced by this new driver:
> > >> 
> > >>   a463696: [SCSI] cnic: Add new Broadcom CNIC driver.
> > > 
> > > I just posted a patch for this to netdev and it was acked by its maintainer.
> > > Patch is below.
> > 
> > I was hoping the scsi folks, or Linus directly, would pick this up.
> 
> I can, but my first tree's just gone ... the next one won't be 
> going until nearer the merge window.

The thing is, this driver has been submitted 4 days ago, merged by 
you 3 days ago and sent upstream two days ago. It has two build 
breakages so far, the first one of which triggered on a pretty 
common config too.

If you have time for such speedy integration but then dont have time 
to test on common configs and dont have time to follow up on and 
fix/merge the (pretty much inevitable) upstream breakages you 
introduce and get the fixes to Linus, sending prompt fixes next-day 
preferably, out of your usual schedule, it would be a better 
solution for you to submit new drivers to the staging tree i think - 
which does have the capacity to fix and merge such stuff.

	Ingo
