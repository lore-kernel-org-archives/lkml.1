Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZFGNCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZFGNCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZFGM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:56:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbZFGM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:56:43 -0400
Date: Sun, 7 Jun 2009 13:56:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations be valid C
Message-ID: <20090607125642.GH8633@ZenIV.linux.org.uk>
References: <20090515195520.GA7715@damson.getinternet.no> <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com> <20090606062514.GA8904@ZenIV.linux.org.uk> <20090607092054.GA31286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607092054.GA31286@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:20:54AM +0200, Ingo Molnar wrote:
> > > > According to Al Viro, the syntax we were using (putting #ifdef inside
> > > > macro arguments) was not valid C. He also suggested using begin/end
> > > > markers instead, which is what we do now.
> > > >
> > > > Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > > 
> > > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Al, are you okay with this?
> > 
> > Looks sane
> 
> Thanks.
> 
> This removes the blocker bug from kmemcheck and we can try to push 
> it in the .31 merge window. Does the level and amount of bit-field 
> annotations look unduly troublesome to you? If we merge kmemcheck 
> then we'll have these type annotations forever.

What had been posted in this thread didn't look over the top for me, but
it's really a question for maintainers of the affected code...
