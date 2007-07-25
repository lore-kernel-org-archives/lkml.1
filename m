Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbXGYWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbXGYWSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXGYWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:18:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757099AbXGYWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:18:04 -0400
Date: Wed, 25 Jul 2007 15:12:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org
Subject: Re: Problems with timerfd()
Message-Id: <20070725151252.8d2d5141.akpm@linux-foundation.org>
In-Reply-To: <46A7940B.4070901@gmx.net>
References: <46A44B7D.3030700@gmx.net>
	<20070722233826.20efa6e5.akpm@linux-foundation.org>
	<46A7940B.4070901@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 20:18:51 +0200
Michael Kerrisk <mtk-manpages@gmx.net> wrote:

> Andrew,
> 
> Andrew Morton wrote:
> > On Mon, 23 Jul 2007 08:32:29 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > 
> >> Andrew,
> >>
> >> The timerfd() syscall went into 2.6.22.  While writing the man page for
> >> this syscall I've found some notable limitations of the interface, and I am
> >> wondering whether you and Linus would consider having this interface fixed
> >> for 2.6.23.
> >>
> >> On the one hand, these fixes would be an ABI change, which is of course
> >> bad.  (However, as noted below, you have already accepted one of the ABI
> >> changes that I suggested into -mm, after Davide submitted a patch.)
> >>
> >> On the other hand, the interface has not yet made its way into a glibc
> >> release, and the change will not break applications.  (The 2.6.22 version
> >> of the interface would just be "broken".)
> > 
> > I think if the need is sufficient we can do this: fix it in 2.6.23 and in
> > 2.6.22.x.  That means that there will be a few broken-on-new-glibc kernels
> > out in the wild, but very few I suspect.
> 
> So I'm still not quite clear.  Can I take it from your statement above that
> the proposed ABI changes would be admissible, as long as Davide is okay
> with them?
> 

yup, I'll send that diff into Linus and -stable and see what happens.

