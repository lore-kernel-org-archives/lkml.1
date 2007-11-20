Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXKTGIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXKTGIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbXKTGIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:08:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbXKTGIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:08:40 -0500
Date: Tue, 20 Nov 2007 07:08:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <greg@kroah.com>, David <david@unsolicited.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>, gregkh@suse.de,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120060808.GG20436@elte.hu>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <20071118005538.GD26865@elte.hu> <47422AA3.7060507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47422AA3.7060507@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> On 11/17/2007 07:55 PM, Ingo Molnar wrote:
> > * Greg KH <greg@kroah.com> wrote:
> > 
> >> Great, thanks for tracking this down.
> >>
> >> Ingo, this corrisponds to changeset 
> >> a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch 
> >> incorrect?  Should this patch in the -stable tree be reverted?
> > 
> > hm, there are no such problems in .24 and the cpu_clock() and other 
> > fixes i did were not picked up. Find the missing fixes below. They 
> > should work just fine in .23 as it has the cpu_clock() functionality 
> > too.
> > 
> > [ NOTE: the most robust thing is to make the .23 version match the .24
> >   version of kernel/softlockup.c, so i included two other harmless
> >   changes in this diff as well. ]
> > 
> > 	Ingo
> > 
> > ----------->
> > commit a5f2ce3c6024a5bb895647b6bd88ecae5001020a
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Tue Oct 16 23:26:08 2007 -0700
> > 
> > commit 43581a10075492445f65234384210492ff333eba
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Tue Oct 16 23:26:08 2007 -0700
> 
> Those are just cosmetic / cleanup changes.
> 
> Don't you need commit a3b13c23f186ecb57204580cc1f2dbe9c284953a ??

yes:

> > [...] the cpu_clock() and other fixes i did were not picked up.

i just forgot to attach the cpu_clock() changes - they are in a3b13c23.

	Ingo
