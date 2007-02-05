Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbXBEVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbXBEVt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933498AbXBEVt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:49:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35158 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496AbXBEVtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:49:55 -0500
Date: Mon, 5 Feb 2007 13:49:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170711587.29759.909.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
 <1170711587.29759.909.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, David Woodhouse wrote:

> On Mon, 2007-02-05 at 13:28 -0800, Linus Torvalds wrote:
> > Right. Because for MOST scsi drivers, it's obvious that they are SCSI to 
> > the user.
> 
> Really? Including the 'Scanner driver' card which arrived with my
> scanner?

Can you read? Can you UNDERSTAND?

This is exactly my point.

If it's not obviously a SCSI card, then it shouldn't be "depends on SCSI". 
It should be on its own and "select SCSI".

The whole AND ALMOST ONLY point of "depends on" is really to allow people 
to do a shorthand or know that "ok, he gave us some information that makes 
this choice pointless".

And yes, we've messed that up. But you're apparently arguing that the 
mess-up is something "good".

"select" is _good_. Because it's the thing that avoids us having to ask 
totally inane questions THAT DO NOT MAKE SENSE to a user.

It's totally idiotic that we should ask people for SCSI support. That's 
not a user question, unless we're talking "odd-ball obviously SCSI 
devices", and then the question actually makes sense as a way to allow 99% 
of all users to say "nope" and not have to see another million questions 
that aren't relevant to them.

			Linus
