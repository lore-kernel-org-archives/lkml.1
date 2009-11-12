Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZKLOlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZKLOlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZKLOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:41:03 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52904 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbZKLOlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:41:02 -0500
Subject: Re: [RFC] new -stable tag variant, Git workflow question
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain>
References: <20091110034831.GB26809@elte.hu>
	 <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>
	 <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>
	 <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
	 <1257970010.11985.17.camel@mulgrave.site>
	 <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
	 <4AFB301C.3050800@zytor.com>
	 <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 08:41:03 -0600
Message-Id: <1258036863.2760.0.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 13:52 -0800, Linus Torvalds wrote:
> 
> On Wed, 11 Nov 2009, H. Peter Anvin wrote:
> > > 
> > > Quite frankly, I'd much rather not run hooks on my tree directly. The less 
> > > that can possibly get screwed up with my kernel.org tree, the happier I 
> > > am. So in many ways, I really prefer the whole "done separately by others" 
> > > approach.
> > > 
> > > But hey, send the hook to me, and I'll think about it.
> > 
> > One thing we might be able to do is to create an "exploder hook" on your
> > tree - something that asynchronously broadcasts a notification that
> > anyone can subscribe to.
> 
> Yeah, some minimal hook just informing any interested party about "ok, 
> Linus pushed to the main tree" (and in fact, perhaps generalized so that 
> you can show that you are interested in some particular branch of _any_ 
> tree that people can just add to their trees) certainly doesn't sound like 
> a bad idea.
> 
> That way we can get rid of "polling by cron", without having to have the 
> tree owners themselves care about who is interested in exactly what..

Sure, I'd like to hook into this rather than use a polling cron job.

James


