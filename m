Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYKZDK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYKZDK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYKZDKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:10:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYKZDKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:10:17 -0500
Date: Wed, 26 Nov 2008 04:09:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Julia Lawall <julia@diku.dk>, jdmason@kudzu.us, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] arch/x86/kernel/pci-calgary_64.c: change
	simple_strtol to simple_strtoul
Message-ID: <20081126030938.GD8242@elte.hu>
References: <Pine.LNX.4.64.0811251412330.11897@pc-004.diku.dk> <20081125144355.GB9912@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125144355.GB9912@il.ibm.com>
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


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Tue, Nov 25, 2008 at 02:13:03PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Since bridge is unsigned, it would seem better to use simple_strtoul that
> > simple_strtol.
> > 
> > A simplified version of the semantic patch that makes this change is as
> > follows: (http://www.emn.fr/x-info/coccinelle/)
> > 
> > // <smpl>
> > @r2@
> > long e;
> > position p;
> > @@
> > 
> > e = simple_strtol@p(...)
> > 
> > @@
> > position p != r2.p;
> > type T;
> > T e;
> > @@
> > 
> > e = 
> > - simple_strtol@p
> > + simple_strtoul
> >   (...)
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> Ingo, can you please push?

Sure, applied to tip/x86/urgent, thanks guys!

	Ingo
