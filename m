Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbXGXANn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbXGXANn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXGXANh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:13:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411AbXGXANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:13:36 -0400
Date: Mon, 23 Jul 2007 17:12:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Message-Id: <20070723171238.1a832b31.akpm@linux-foundation.org>
In-Reply-To: <1184980678.6344.1.camel@localhost.localdomain>
References: <1184980678.6344.1.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 11:17:58 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> The netfilter code had very good documentation: the Netfilter Hacking
> HOWTO.  Noone ever read it.
> 
> So this time I'm trying something different, using a bit of
> Knuthiness.  Start with drivers/lguest/README.

um.

I'm OK with merging patches and given lguest's newness, the timestamp on
these patches, the fact that they don't change code generation (right?) and
my reluctance to carry large do-nothing patches for two months, I'd be OK
with squeaking them into 2.6.23.

But I worry that you're proposing adding what appears to be new
Documentation-related machinery and infrastructure when there's already
increased activity in that area from other people and we might all be
headed in different directions and stuff.

So first I think we'd best form a kernel kommittee and mull this for a
while (preferably months) to screw you around as much as poss, OK?  ;)

Items for consideration would be:

- if this stuff is good, shouldn't other code be using it?  If so, is
  this new infrastructure in the correct place?

- if, otoh, this infrastructure is _not_ suitable for other code, well,
  what was wrong with it?

- if the requirement is good, perhaps alternative implementations should
  be explored (dunno what).


IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
please.
