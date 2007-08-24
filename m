Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXHXQYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXHXQYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXHXQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:23:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40710 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbXHXQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:23:52 -0400
Date: Fri, 24 Aug 2007 09:17:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Kees Cook <kees@outflux.net>
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
 MAP_32BIT? - mono crashes
Message-ID: <20070824091720.4c6f4227@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0708240157430.5402@jikos.suse.cz>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<1187834905.190825.16.camel@localhost>
	<Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
	<20070823165201.717ed62d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708240157430.5402@jikos.suse.cz>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 02:09:59 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> (some more CCs added)
> 
> On Thu, 23 Aug 2007, Andrew Morton wrote:
> 
> > It is quite unobvious to me that the whole pie-randomization thing
> > is worth merging.  Why shouldn't we just drop the lot?
> 
> Hi Andrew,
> 
> well, whenever it comes to address space layout randomization, there 
> usually follows a huge debate whether it is needed or not, some
> people think it's useful and powerful security protection against
> 0day attacks, other people think that it's just fighting the bugs in
> userspace software in a wrong way.

randomizing PIE's is as a whole worth getting right and in mainline.
That means that ONLY the PIE text should be randomized, not that mmap
should break ;)

Randomizing address space is very widely recognized as being part of a
whole set of things (and there's a lot of discussion about what that
whole set should be, each vendor will say their solution should be part
of that and that all others suck) that you need to do to make it a LOT
harder to get a general purpose exploit working. (It's not fool proof;
it's more comparable than a 4 tumble number lock than it is to a iris
scan; yet even a tumble number lock makes it harder to break into your
gym locker)
