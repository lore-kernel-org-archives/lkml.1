Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZFGJVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZFGJVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZFGJVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:21:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZFGJVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:21:00 -0400
Date: Sun, 7 Jun 2009 11:20:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations be valid C
Message-ID: <20090607092054.GA31286@elte.hu>
References: <20090515195520.GA7715@damson.getinternet.no> <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com> <20090606062514.GA8904@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606062514.GA8904@ZenIV.linux.org.uk>
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, May 16, 2009 at 09:40:08AM +0300, Pekka Enberg wrote:
> > On Fri, May 15, 2009 at 10:55 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > From bb8926742d87da95aeb373bc2d4b35a554c5001b Mon Sep 17 00:00:00 2001
> > > From: Vegard Nossum <vegard.nossum@gmail.com>
> > > Date: Fri, 15 May 2009 21:34:36 +0200
> > > Subject: [PATCH] kmemcheck: make bitfield annotations be valid C
> > >
> > > According to Al Viro, the syntax we were using (putting #ifdef inside
> > > macro arguments) was not valid C. He also suggested using begin/end
> > > markers instead, which is what we do now.
> > >
> > > Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> > > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > 
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Al, are you okay with this?
> 
> Looks sane

Thanks.

This removes the blocker bug from kmemcheck and we can try to push 
it in the .31 merge window. Does the level and amount of bit-field 
annotations look unduly troublesome to you? If we merge kmemcheck 
then we'll have these type annotations forever.

	Ingo
