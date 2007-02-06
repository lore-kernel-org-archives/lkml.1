Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXBFXS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXBFXS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030553AbXBFXS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:18:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXBFXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:18:28 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061505400.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	 <1170711587.29759.909.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
	 <1170712393.29759.925.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
	 <20070205143110.fca62b57.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
	 <1170717694.29759.941.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
	 <1170755101.29759.960.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
	 <1170801484.29759.1000.camel@pmac.infradead.org>
	 <20070206143956.b09c674d.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0702061505400.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 23:18:20 +0000
Message-Id: <1170803900.29759.1040.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:11 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Feb 2007, Randy Dunlap wrote:
> > > But it doesn't matter. I'll come up with a hack for the tools which make
> > > them (optionally) treat 'select' of a user-visible option as if it
> > > was just 'depends on'. And that should fix the problem.
> >
> > Yes, that's the solution that I decided on during lunch also:
> > 	select <==> depends on
> 
> I think yuou can certainly enable an "expert mode", which just reads 
> "select" as "depends on".
> 
> You'll probably have to do *more* changes to the tools than my suggestion 
> to just make them let you know why they can't turn something off, though. 
> Why? Some things don't even have questions at all right now, and their 
> only life is as implied options that are turned on by others.
> 
> And yes, some silly people who hate "select" have tried to turn them into

Out of interest, which people would this be? Not me, certainly.
I _use_ select, for options which don't have questions. There were two
such instances in the context of Ingo's mail of $subject, even.

And the thing Randy was saying "yes" to, which you elided but I've
restored in the above quotation, was the idea of turning 'select' into
'depends on' for _user-visible_ options. NOT for the ones which don't
have a question.

-- 
dwmw2

