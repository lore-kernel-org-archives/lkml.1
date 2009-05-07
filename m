Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbZEGPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbZEGPEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZEGPEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:04:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbZEGPET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:04:19 -0400
Date: Thu, 7 May 2009 17:04:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb,early_printk: insert cr prior to nl as needed
Message-ID: <20090507150401.GC2344@elte.hu>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <1241575205-12199-3-git-send-email-jason.wessel@windriver.com> <1241575205-12199-4-git-send-email-jason.wessel@windriver.com> <20090506073025.GB17457@elte.hu> <20090506152555.GB4603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506152555.GB4603@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> On Wed, May 06, 2009 at 09:30:25AM +0200, Ingo Molnar wrote:
> > 
> > * Jason Wessel <jason.wessel@windriver.com> wrote:
> > 
> > > The rs232 drivers send a carriage return prior to a new line in the
> > > early printk code.
> > > 
> > > The usb debug driver should do the same because you want to be able to
> > > use the same terminal programs and tools for analysis of early printk
> > > data.
> > > 
> > > Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> > > ---
> > >  arch/x86/kernel/early_printk.c |   22 ++++++++++++++++------
> > >  1 files changed, 16 insertions(+), 6 deletions(-)
> > 
> > hm, would be better to carry this in the x86 tree - where most of 
> > the early-debug functionality has been authored and maintained. 
> > 
> > Greg, is that fine with you?
> 
> Yes, but it needs a few more rounds to fix the bugs pointed out.  
> So please don't take this one yet.

Sure, will wait for your Acked-by to show up in the changelog.

	Ingo
