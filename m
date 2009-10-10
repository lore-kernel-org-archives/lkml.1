Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbZJJSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbZJJSMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbZJJSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:12:04 -0400
Received: from www.tglx.de ([62.245.132.106]:51013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300AbZJJSMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:12:02 -0400
Date: Sat, 10 Oct 2009 20:10:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
In-Reply-To: <20091010193915.0e34f0e9@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0910102010180.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153350.006406413@linutronix.de> <20091010190436.1a48f98e@hyperion.delvare> <alpine.LFD.2.00.0910101907420.9428@localhost.localdomain> <20091010193915.0e34f0e9@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

On Sat, 10 Oct 2009, Jean Delvare wrote:

> On Sat, 10 Oct 2009 19:09:45 +0200 (CEST), Thomas Gleixner wrote:
> > Jean,
> > 
> > On Sat, 10 Oct 2009, Jean Delvare wrote:
> > > Looks good to me:
> > > 
> > > Acked-by: Jean Delvare <khali@linux-fr.org>
> > > 
> > > Do you want me to pick this patch in my i2c tree, or will you take care
> > > of pushing it upstream? If you're not going to push it quickly, I'd
> > > prefer the first solution, to avoid conflicts.
> > 
> > I'm targeting for .33, but please pick it up. I drop it from my queue
> > then.
> 
> Will do. I guess I can assume that the patch is from Vincent Sanders,
> not you, despite the lack of From: header?

Duh, yes. Missed that.

Thanks,

	tglx
