Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZFFGZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZFFGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZFFGZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:25:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50148 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFFGZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:25:13 -0400
Date: Sat, 6 Jun 2009 07:25:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: make bitfield annotations be valid C
Message-ID: <20090606062514.GA8904@ZenIV.linux.org.uk>
References: <20090515195520.GA7715@damson.getinternet.no> <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 09:40:08AM +0300, Pekka Enberg wrote:
> On Fri, May 15, 2009 at 10:55 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > From bb8926742d87da95aeb373bc2d4b35a554c5001b Mon Sep 17 00:00:00 2001
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Date: Fri, 15 May 2009 21:34:36 +0200
> > Subject: [PATCH] kmemcheck: make bitfield annotations be valid C
> >
> > According to Al Viro, the syntax we were using (putting #ifdef inside
> > macro arguments) was not valid C. He also suggested using begin/end
> > markers instead, which is what we do now.
> >
> > Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Al, are you okay with this?

Looks sane
